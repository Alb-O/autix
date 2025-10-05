{
  lib,
  self,
  config,
  ...
}:
let
  inherit (lib)
    attrValues
    concatStrings
    concatStringsSep
    filterAttrs
    flatten
    foldl'
    hasPrefix
    imap0
    mapAttrs
    replicate
    ;

  inherit (config.autix) aspects;

  # Create mapping from directory names to aspect descriptions
  aspectDescriptions = mapAttrs (_: aspect: aspect.description or "") aspects;

  modPath = self + "/modules";

  # Read comment from .gitattributes file if it exists
  # Format: # description: Your comment here
  readGitAttributesComment =
    path:
    let
      attrFile = path + "/.gitattributes";
      fileExists = builtins.pathExists attrFile;
    in
    if !fileExists then
      ""
    else
      let
        content = builtins.readFile attrFile;
        lines = lib.splitString "\n" content;
        # Find line starting with "# description: "
        commentLines = builtins.filter (line: lib.hasPrefix "# description: " line) lines;
      in
      if commentLines == [ ] then
        ""
      else
        let
          line = builtins.head commentLines;
          # Extract text after "# description: "
          afterPrefix = lib.removePrefix "# description: " line;
        in
        lib.trim afterPrefix;

  # Read directory and filter out hidden/ignored items
  readDirFiltered =
    path:
    let
      entries = builtins.readDir path;
      # Filter out files/dirs starting with _ or .
      visible = filterAttrs (name: _: !(hasPrefix "_" name) && !(hasPrefix "." name)) entries;
    in
    visible;

  # Get immediate subdirectories of modules/
  topLevelDirs = readDirFiltered modPath;
  topLevelNames = builtins.attrNames topLevelDirs;
  topLevelCount = builtins.length topLevelNames;

  # Calculate maximum name length for top-level dirs (with slash)
  maxTopLevelLen = foldl' (
    max: name:
    let
      len = builtins.stringLength name + 1; # +1 for trailing slash
    in
    if len > max then len else max
  ) 0 topLevelNames;

  # Calculate maximum name length for subdirectories in each top-level dir
  maxSubLengthPerDir = mapAttrs (
    name: type:
    let
      fullPath = modPath + "/${name}";
      subDirs = if type == "directory" then readDirFiltered fullPath else { };
      subNames = builtins.attrNames subDirs;
    in
    foldl' (
      max: subName:
      let
        subType = subDirs.${subName};
        suffix = if subType == "directory" then "/" else "";
        len = builtins.stringLength subName + builtins.stringLength suffix;
      in
      if len > max then len else max
    ) 0 subNames
  ) topLevelDirs;

  # Find the global maximum for all subdirectories
  maxSubLen = foldl' (max: len: if len > max then len else max) 0 (attrValues maxSubLengthPerDir);

  # Generate tree lines for each top-level directory
  generateSubTree =
    idx: name:
    let
      isLast = idx == (topLevelCount - 1);
      prefix = if isLast then "└──" else "├──";
      continueBar = if isLast then "    " else "│   ";

      type = topLevelDirs.${name};
      fullPath = modPath + "/${name}";
      subDirs = if type == "directory" then readDirFiltered fullPath else { };
      subNames = builtins.attrNames subDirs;
      subCount = builtins.length subNames;

      # Main directory comment - try .gitattributes first, then hardcoded
      gitAttrComment = readGitAttributesComment fullPath;
      commentText =
        if gitAttrComment != "" then
          gitAttrComment
        else if name == "aspect" then
          "Aspect system core (aggregation, options)"
        else if name == "flake" then
          "Flake-level configuration (formatter, nix config, file generation)"
        else if name == "hm" then
          "Home Manager aspects and profiles"
        else if name == "sys" then
          "System-level configuration"
        else
          "";

      # Calculate padding for alignment
      nameWithSlash = "${name}/";
      nameLen = builtins.stringLength nameWithSlash;
      padding = concatStrings (replicate (maxTopLevelLen - nameLen + 1) " ");
      comment = if commentText != "" then "${padding}# ${commentText}" else "";

      mainLine = "${prefix} ${nameWithSlash}${comment}";

      # Generate lines for subdirectories
      subLines = imap0 (
        subIdx: subName:
        let
          subIsLast = subIdx == (subCount - 1);
          subPrefix = if subIsLast then "└──" else "├──";
          subType = subDirs.${subName};
          suffix = if subType == "directory" then "/" else "";

          # Try to find description: .gitattributes > aspect description > hardcoded
          subFullPath = fullPath + "/${subName}";
          gitAttrComment = if subType == "directory" then readGitAttributesComment subFullPath else "";

          aspectDesc = aspectDescriptions.${subName} or "";

          commentText =
            if gitAttrComment != "" then
              gitAttrComment
            else if subName == "+profiles" then
              "Profile definitions and options"
            else if aspectDesc != "" then
              aspectDesc
            else
              "";

          # Calculate padding for alignment
          nameWithSuffix = "${subName}${suffix}";
          nameLen = builtins.stringLength nameWithSuffix;
          padding = concatStrings (replicate (maxSubLen - nameLen) " ");
          subComment = if commentText != "" then "${padding}  # ${commentText}" else "";
        in
        "${continueBar}${subPrefix} ${nameWithSuffix}${subComment}"
      ) subNames;
    in
    [ mainLine ] ++ subLines;

  allLines = flatten (imap0 generateSubTree topLevelNames);

  tree = concatStringsSep "\n" allLines;
in
{
  options.text.readme.tree = lib.mkOption {
    type = lib.types.str;
    default = tree;
    readOnly = true;
    description = "Generated directory tree for modules/ structure";
  };
}
