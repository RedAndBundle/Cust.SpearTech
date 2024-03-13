permissionset 80601 "PTEPI Spear PI Admin"
{
    Caption = 'Spear PI Admin';
    Assignable = true;

    Permissions =
        tabledata "PTEPI Spear PI Setup" = RIMD,
        tabledata "PTEPI API PI Header" = RIMD,
        tabledata "PTEPI API PI Line" = RIMD;
}