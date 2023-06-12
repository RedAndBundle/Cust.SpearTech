page 80405 "PTE Run Check All Batches"
{
    Caption = 'Run Check All Batches';
    PageType = List;
    SourceTable = "PTE Run Check Batch";
    ApplicationArea = All;
    usagecategory = Tasks;
    InsertAllowed = false;
    Deleteallowed = false;
    // ModifyAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the name of the journal you are creating.';
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a brief description of the journal batch you are creating.';
                    Editable = false;
                }
                field(RunCheck; Rec."Run Check")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a checks are created for this batch.';
                }
                field(BankAccountNo; Rec."Bank Account No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the bank account from which the checks are drawn.';
                }
                field(LastCheckNo; Rec."Last Check No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of the last check that was created for this bank account.';
                }
                field("Reprint Checks"; Rec."Reprint Checks")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies that the check is reprinted.';
                }
                field("One Check Per Vendor"; Rec."One Check Per Vendor")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies that only one check is printed per vendor.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(RunChecks)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Run Checks';
                Image = PrintCheck;
                ToolTip = 'Prints checks for all batches.';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Rec.PrintChecks();
                end;
            }
        }
    }

    trigger OnInit()
    begin
        Rec.GetBatches();
    end;
}

