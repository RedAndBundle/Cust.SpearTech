page 80409 "PTE Check PDF Files"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "PTE Check PDF File";
    Caption = 'Check PDF Files';
    CardPageId = "PTE Check PDF File";

    layout
    {
        area(Content)
        {
            repeater(Repeater)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Filename"; Rec."Filename")
                {
                    ApplicationArea = All;
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ApplicationArea = All;
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Download)
            {
                ApplicationArea = All;
                Caption = 'Download';
                ToolTip = 'Download the pdf file to your local computer.';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = Download;
                trigger OnAction()
                begin
                    Rec.Download();
                end;
            }
            action(Cleanup)
            {
                ApplicationArea = All;
                Caption = 'Cleanup';
                ToolTip = 'Delete all pdf files older than 7 days.';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = ClearLog;
                trigger OnAction()
                begin
                    Rec.Cleanup();
                end;
            }
        }
    }
}