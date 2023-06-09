// page 80503 "PTEAP AP Entries"
// {
//     PageType = List;
//     ApplicationArea = All;
//     UsageCategory = Lists;
//     SourceTable = "PTEAP AP Entry";
//     Caption = 'Speartech AP Entries';

//     layout
//     {
//         area(Content)
//         {
//             repeater(GroupName)
//             {
//                 field("Entry No."; Rec."Entry No.") { ApplicationArea = All; }
//                 field("Document Type"; Rec."Document Type") { ApplicationArea = All; }
//                 field("Document No."; Rec."Document No.") { ApplicationArea = All; }
//                 field("Line No."; Rec."Line No.") { ApplicationArea = All; }
//                 field("Sell-to Customer No."; Rec."Sell-to Customer No.") { ApplicationArea = All; }
//                 field("Bill-To Customer No."; Rec."Bill-To Customer No.") { ApplicationArea = All; }
//                 field("Claim Number"; Rec."Claim Number") { ApplicationArea = All; }
//                 field("Claimant Name"; Rec."Claimant Name") { ApplicationArea = All; }
//                 field(SSN; Rec.SSN) { ApplicationArea = All; }
//                 field(DOB; Rec.DOB) { ApplicationArea = All; }
//                 field("Claims Manager"; Rec."Claims Manager") { ApplicationArea = All; }
//                 field("Referral Date"; Rec."Referral Date") { ApplicationArea = All; }
//                 field("Task/Activity"; Rec."Task/Activity") { ApplicationArea = All; }
//                 field("Task Code"; Rec."Task Code") { ApplicationArea = All; }
//                 field("Task Date"; Rec."Task Date") { ApplicationArea = All; }
//                 field(Units; Rec.Units) { ApplicationArea = All; }
//                 field(Rate; Rec.Rate) { ApplicationArea = All; }
//                 field(Amount; Rec.Amount) { ApplicationArea = All; }
//                 field(Description; Rec.Description) { ApplicationArea = All; }
//             }
//         }
//         area(Factboxes)
//         {

//         }
//     }

//     actions
//     {
//         area(Processing)
//         {
//             action(ActionName)
//             {
//                 ApplicationArea = All;

//                 trigger OnAction();
//                 begin

//                 end;
//             }
//         }
//     }
// }