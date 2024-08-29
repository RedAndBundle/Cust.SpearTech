permissionset 80403 "PTE SpearTech API"
{
    Caption = 'Spear Check API';
    Assignable = true;
    IncludedPermissionSets = "D365 Basic", "D365 VENDOR, VIEW", "D365 VENDOR, EDIT";

    Permissions =
        tabledata "PTE Check Data" = RIMD,
        tabledata "PTE Spear Technology Setup" = R,
        tabledata "PTE Spear Account" = R;
}