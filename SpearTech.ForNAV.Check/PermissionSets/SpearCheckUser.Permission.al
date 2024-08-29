permissionset 80402 "PTE SpearCheckUser"
{
    Caption = 'Spear Check User';
    Assignable = true;

    Permissions =
        tabledata "PTE Check Data" = R,
        tabledata "PTE Spear Technology Setup" = R,
        tabledata "PTE Spear Account" = R;
}