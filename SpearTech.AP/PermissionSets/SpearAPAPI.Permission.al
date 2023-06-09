permissionset 80500 "PTEAP Spear AP API"
{
    Caption = 'Spear AP API';
    Assignable = true;
    IncludedPermissionSets = "D365 Basic", "D365 CUSTOMER, VIEW", "D365 CUSTOMER, EDIT";

    Permissions =
        tabledata "PTEAP Spear AP Setup" = RIMD,
        tabledata "PTEAP API AP Header" = RIMD,
        tabledata "PTEAP API AP Line" = RIMD;
}