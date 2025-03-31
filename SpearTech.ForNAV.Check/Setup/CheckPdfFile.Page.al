page 80411 "PTE Check PDF File"
{
    PageType = Card;
    SourceTable = "PTE Check PDF File";
    Caption = 'Check PDF File';

    layout
    {
        area(Content)
        {
            group(pdf)
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
                ToolTip = 'Download the PDF file to your local computer.';
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
        }
    }
}