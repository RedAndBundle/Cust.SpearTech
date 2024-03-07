permissionset 80600 "PTEPI Spear PI API"
{
    Caption = 'Spear PI API';
    Assignable = true;
    IncludedPermissionSets = "D365 Basic", "D365 CUSTOMER, VIEW", "D365 CUSTOMER, EDIT";

    Permissions =
        tabledata "PTEPI Spear PI Setup" = RIMD,
        tabledata "PTEPI API PI Header" = RIMD,
        tabledata "PTEPI API PI Line" = RIMD;
}