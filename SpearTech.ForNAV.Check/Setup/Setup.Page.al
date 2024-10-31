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
                field("One Check No Per Check"; Rec."One Check No Per Check")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if the check number should be incremented for each page of the check. If checked multipage checks will only have a single check number.';
                }
            }
            group(PDF)
            {
                Caption = 'PDF';
                field("PDF Merge Webservice"; Rec."PDF Merge Webservice") { ApplicationArea = All; }
                field("PDF Merge Key"; Rec."PDF Merge Key") { ApplicationArea = All; }

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