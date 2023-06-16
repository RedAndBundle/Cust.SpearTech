page 80402 "PTE Check Data"
{
    PageType = List;
    Caption = 'Check Data';
    ApplicationArea = Basic, Suite;
    UsageCategory = Lists;
    SourceTable = "PTE Check Data";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Document Number"; Rec."Document Number") { ApplicationArea = Basic, Suite; }
                field(FileName; Rec.Filename)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Caption = 'PDF';
                }
                field(Client; Rec.Client) { ApplicationArea = Basic, Suite; }
                field("TIN SSN"; Rec."TIN SSN") { ApplicationArea = Basic, Suite; }
                field("Claim Number"; Rec."Claim Number") { ApplicationArea = Basic, Suite; }
                field("Claimant Name"; Rec."Claimant Name") { ApplicationArea = Basic, Suite; }
                field("Loss Date"; Rec."Loss Date") { ApplicationArea = Basic, Suite; }
                field("Payment Type"; Rec."Payment Type") { ApplicationArea = Basic, Suite; }
                field("From Date"; Rec."From Date") { ApplicationArea = Basic, Suite; }
                field("Through Date"; Rec."Through Date") { ApplicationArea = Basic, Suite; }
                field("Invoice Date"; Rec."Invoice Date") { ApplicationArea = Basic, Suite; }
                field("Invoice No."; Rec."Invoice No.") { ApplicationArea = Basic, Suite; }
                field("Carrier Name 1"; Rec."Carrier Name 1") { ApplicationArea = Basic, Suite; }
                field("Carrier Name 2"; Rec."Carrier Name 2") { ApplicationArea = Basic, Suite; }
                field(Comment; Rec.Comment) { ApplicationArea = Basic, Suite; }
                field(Department; Rec.Department) { ApplicationArea = Basic, Suite; }
                field("Adjuster Name"; Rec."Adjuster Name") { ApplicationArea = Basic, Suite; }
                field("Adjuster Phone"; Rec."Adjuster Phone") { ApplicationArea = Basic, Suite; }
                field("Event Number"; Rec."Event Number") { ApplicationArea = Basic, Suite; }
                field("Control Number"; Rec."Control Number") { ApplicationArea = Basic, Suite; }
                field("Additional Payee"; Rec."Additional Payee") { ApplicationArea = Basic, Suite; }
                field("Additional Payee Text"; Rec."Additional Payee Text") { ApplicationArea = Basic, Suite; }
                field("Group Claimant Vendor Checks"; Rec."Group Claimant Vendor Checks") { ApplicationArea = Basic, Suite; }
                field("Claimant Id"; Rec."Claimant Id") { ApplicationArea = Basic, Suite; }
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
                ApplicationArea = Basic, Suite;
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