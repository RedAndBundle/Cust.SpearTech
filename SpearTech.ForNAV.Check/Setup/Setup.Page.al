page 80410 "PTE Spear Technologies Setup"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "PTE Spear Technology Setup";
    InsertAllowed = false;
    DeleteAllowed = false;
    Caption = 'Spear Technologies Setup';

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("G/L Account No."; Rec."G/L Account No.") { ApplicationArea = All; }
                field("Payment Method (Check)"; Rec."Payment Method (Check)") { ApplicationArea = All; }
                field("Payment Method (EFT)"; Rec."Payment Method (EFT)") { ApplicationArea = All; }
                field("Payment Method (Void)"; Rec."Payment Method (Void)") { ApplicationArea = All; }
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