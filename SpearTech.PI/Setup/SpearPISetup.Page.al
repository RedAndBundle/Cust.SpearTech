page 80604 "PTEPI Spear PI Setup"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "PTEPI Spear PI Setup";
    InsertAllowed = false;
    DeleteAllowed = false;
    Caption = 'Spear PI Setup';

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
                    ToolTip = 'Specifies the item template that will be used for unused task codes sent through the PI API.';
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