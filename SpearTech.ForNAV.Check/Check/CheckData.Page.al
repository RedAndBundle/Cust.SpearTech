page 80402 "PTE Check Data"
{
    PageType = List;
    Caption = 'Check Data';
    ApplicationArea = Basic;
    UsageCategory = Lists;
    SourceTable = "PTE Check Data";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Document Number"; Rec."Document Number") { ApplicationArea = Basic; }
                field("External Document No."; Rec."External Document No.") { ApplicationArea = Basic; }
                field(FileName; Rec.Filename)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Caption = 'PDF';
                }
                field(Client; Rec.Client) { ApplicationArea = Basic; }
                field("TIN SSN"; Rec."TIN SSN") { ApplicationArea = Basic; }
                field("Claim Number"; Rec."Claim Number") { ApplicationArea = Basic; }
                field("Claimant Name"; Rec."Claimant Name") { ApplicationArea = Basic; }
                field("Loss Date"; Rec."Loss Date") { ApplicationArea = Basic; }
                field("Payment Type"; Rec."Payment Type") { ApplicationArea = Basic; }
                field("From Date"; Rec."From Date") { ApplicationArea = Basic; }
                field("Through Date"; Rec."Through Date") { ApplicationArea = Basic; }
                field("Invoice Date"; Rec."Invoice Date") { ApplicationArea = Basic; }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ViewLogo)
            {
                ApplicationArea = Basic;
                Caption = 'View PDF';
                ToolTip = 'Downloads the PDF.';
                Image = Picture;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction();
                begin
                    Rec.DownloadPDF();
                end;

            }
        }
    }
}