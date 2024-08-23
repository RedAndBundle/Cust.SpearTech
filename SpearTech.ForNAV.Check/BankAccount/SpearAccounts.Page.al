page 80408 "PTE Spear Accounts"
{
    Caption = 'Spear Accounts';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "PTE Spear Account";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Spear Account No."; Rec."Spear Account No.")
                {
                    ApplicationArea = All;
                }
                field("Last Check No."; Rec."Last Check No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    trigger OnInit()
    begin
        Rec.FindBankAccountNumbers();
    end;
}