permissionset 80501 "PTEAP Spear AP Admin"
{
    Caption = 'Spear AP Admin';
    Assignable = true;

    Permissions =
        tabledata "PTEAP Spear AP Setup" = RIMD,
        tabledata "PTEAP API AP Header" = RIMD,
        tabledata "PTEAP API AP Line" = RIMD;
}