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

  # Filter out hidden/ignored items
  readDirFiltered =
    path:
    let
      entries = builtins.readDir path;
      visible = filterAttrs (name: _: !(hasPrefix "_" name) && !(hasPrefix "." name)) entries;
    in
    visible;

  # Immediate subdirs of modules/
  topLevelDirs = readDirFiltered modPath;
  topLevelNames = builtins.attrNames topLevelDirs;
  topLevelCount = builtins.length topLevelNames;

  # Calculate max name length for top-level dirs
  maxTopLevelLen = foldl' (
    max: name:
    let
      len = builtins.stringLength name + 1;
    in
    if len > max then len else max
  ) 0 topLevelNames;

  # Calculate max name length for subdirs in each top-level dir
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

  maxSubLen = foldl' (max: len: if len > max then len else max) 0 (attrValues maxSubLengthPerDir);

  # Tree lines for each top-level directory
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

      # Top-level aspect description
      aspectDesc = aspectDescriptions.${name} or "";

      # Alignment padding for top-level
      nameWithSlash = "${name}/";
      nameLen = builtins.stringLength nameWithSlash;
      padding = concatStrings (replicate (maxTopLevelLen - nameLen + 1) " ");
      comment = if aspectDesc != "" then "${padding}# ${aspectDesc}" else "";

      mainLine = "${prefix} ${nameWithSlash}${comment}";

      # Generate lines for subdirs
      subLines = imap0 (
        subIdx: subName:
        let
          subIsLast = subIdx == (subCount - 1);
          subPrefix = if subIsLast then "└──" else "├──";
          subType = subDirs.${subName};
          suffix = if subType == "directory" then "/" else "";

          # Alignment padding for subdir
          nameWithSuffix = "${subName}${suffix}";
          nameLen = builtins.stringLength nameWithSuffix;
          padding = concatStrings (replicate (maxSubLen - nameLen) " ");
          subAspectDesc = aspectDescriptions.${subName} or "";
          subComment = if subAspectDesc != "" then "${padding}  # ${subAspectDesc}" else "";
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
