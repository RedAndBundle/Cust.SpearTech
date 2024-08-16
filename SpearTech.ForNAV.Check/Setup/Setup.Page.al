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
                field("Generate Check Type"; Rec."Output Type") { ApplicationArea = All; }
            }
            group(PDF)
            {
                Caption = 'PDF';
                field("PDF Merge Webservice"; Rec."PDF Merge Webservice") { ApplicationArea = All; }
                field("PDF Merge Key"; Rec."PDF Merge Key") { ApplicationArea = All; }

            }
            group(GlobalCheckNo)
            {
                Caption = 'Global Check Numbers';
                field("Global Check No."; Rec."Global Check No.")
                {
                    Caption = 'Use Global Check Numbers:';
                    ApplicationArea = All;
                }
                field("Global Last Check No."; Rec."Global Last Check No.")
                {
                    ApplicationArea = All;
                    Editable = Rec."Global Check No.";
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