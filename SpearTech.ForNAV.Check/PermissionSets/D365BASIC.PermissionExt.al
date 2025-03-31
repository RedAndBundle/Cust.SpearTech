permissionsetextension 80400 "PTE D365 BASIC" extends "D365 BASIC"
{
    Permissions =
        tabledata "PTE Check PDF File" = RI,
        tabledata "PTE Check Data" = R,
        tabledata "PTE Spear Technology Setup" = R,
        tabledata "PTE Spear Account" = R;
}