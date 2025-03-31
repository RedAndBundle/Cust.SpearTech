permissionset 80401 "PTE SpearCheckAdmin"
{
    Caption = 'Spear Check Admin';
    Assignable = true;

    Permissions =
        tabledata "PTE Check PDF File" = RIMD,
        tabledata "PTE Check Data" = RIMD,
        tabledata "PTE Spear Technology Setup" = RIMD,
        tabledata "PTE Spear Account" = RIMD;
}