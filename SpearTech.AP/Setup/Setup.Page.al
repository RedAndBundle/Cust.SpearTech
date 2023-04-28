page 80502 "PTEAP Spear AP Setup"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "PTEAP Spear AP Setup";
    InsertAllowed = false;
    DeleteAllowed = false;
    Caption = 'Spear AP Setup';

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("Item Template"; Rec."Item Template")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the item template that will be used for unused task codes sent through the AP API.';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}