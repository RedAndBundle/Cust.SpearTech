// table 80502 "PTEAP AP Entry"
// {
//     DataClassification = CustomerContent;
//     Caption = 'AP Entry';

//     fields
//     {
//         field(1; "Entry No."; Integer)
//         {
//             Caption = 'Entry No.';
//             AutoIncrement = true;
//         }
//         field(2; "Document Type"; Enum "Sales Document Type")
//         {
//             Caption = 'Document Type';
//         }
//         field(3; "Sell-to Customer No."; Code[20])
//         {
//             Caption = 'Sell-to Customer No.';
//             Editable = false;
//             TableRelation = Customer;
//         }
//         field(4; "Document No."; Code[20])
//         {
//             Caption = 'Document No.';
//             TableRelation = "Sales Header"."No." WHERE("Document Type" = FIELD("Document Type"));
//         }
//         field(5; "Line No."; Integer)
//         {
//             Caption = 'Line No.';
//         }
//         field(6; "Bill-To Customer No."; Code[20])
//         {
//             Caption = 'Sell-to Customer No.';
//             Editable = false;
//             TableRelation = Customer;
//         }
//         field(10; "Claim Number"; Text[100])
//         {
//             DataClassification = CustomerContent;
//             Caption = 'Claim Number';
//         }
//         field(11; "Claimant Name"; Text[100])
//         {
//             DataClassification = CustomerContent;
//             Caption = 'Claimant Name';
//         }
//         field(12; "SSN"; Text[100])
//         {
//             DataClassification = CustomerContent;
//             Caption = 'SSN';
//         }
//         field(13; "DOB"; Date)
//         {
//             DataClassification = CustomerContent;
//             Caption = 'DOB';
//         }
//         field(14; "Claims Manager"; Text[100])
//         {
//             DataClassification = CustomerContent;
//             Caption = 'Claims Manager';
//         }
//         field(15; "Referral Date"; Date)
//         {
//             DataClassification = CustomerContent;
//             Caption = 'Referral Date';
//         }

//         // Line Details
//         field(100; "Task/Activity"; Text[100])
//         {
//             DataClassification = CustomerContent;
//             Caption = 'Task/Activity';
//         }
//         field(101; "Task Code"; Code[20])
//         {
//             DataClassification = CustomerContent;
//             Caption = 'Task Code';
//         }
//         field(102; "Task Date"; Date)
//         {
//             DataClassification = CustomerContent;
//             Caption = 'Task Date';
//         }
//         field(103; "Units"; Decimal)
//         {
//             DataClassification = CustomerContent;
//             Caption = 'Units';
//         }
//         field(104; "Rate"; Decimal)
//         {
//             DataClassification = CustomerContent;
//             Caption = 'Rate';
//         }
//         field(105; "Amount"; Decimal)
//         {
//             DataClassification = CustomerContent;
//             Caption = 'Amount';
//         }
//         field(106; "Description"; Text[100])
//         {
//             DataClassification = CustomerContent;
//             Caption = 'Description';
//         }
//     }

//     keys
//     {
//         key(Key1; "Document No.", "Document Type", "Line No.")
//         {
//             Clustered = true;
//         }
//         key(Claim; "Claim Number") { }
//     }
// }