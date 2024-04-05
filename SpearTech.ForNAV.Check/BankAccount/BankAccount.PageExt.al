pageextension 80400 "PTE Bank Account Card" extends "Bank Account Card"
{
    layout
    {
        addlast(content)
        {
            group(PTESpearTech)
            {
                Caption = 'SpearTech';
                field("PTE Check Name"; Rec."PTE Check Name")
                {
                    ApplicationArea = All;
                    Caption = 'Check Name';
                    ToolTip = 'Specifies the name that will be printed on the check.';
                }
                field("PTE Check Name 2"; Rec."PTE Check Name 2")
                {
                    ApplicationArea = All;
                    Caption = 'Check Name 2';
                    ToolTip = 'Specifies the 2nd name that will be printed on the check.';
                }
                field("PTE Check Address"; Rec."PTE Check Address")
                {
                    ApplicationArea = All;
                    Caption = 'Check Address';
                    ToolTip = 'Specifies the address that will be printed on the check.';
                }
                field("PTE Check Address 2"; Rec."PTE Check Address 2")
                {
                    ApplicationArea = All;
                    Caption = 'Check Address 2';
                    ToolTip = 'Specifies the 2nd address that will be printed on the check.';
                }
                field("PTE Check City"; Rec."PTE Check City")
                {
                    ApplicationArea = All;
                    Caption = 'Check City';
                    ToolTip = 'Specifies the city that will be printed on the check.';
                }
                field("PTE Check County"; Rec."PTE Check County")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the county that will be printed on the check.';
                }
                field("PTE Check Country/Region Code"; Rec."PTE Check Country/Region Code")
                {
                    ApplicationArea = All;
                    Caption = 'Check Country/Region Code';
                    ToolTip = 'Specifies the country/region that will be printed on the check.';
                }
                field("PTE Check Post Code"; Rec."PTE Check Post Code")
                {
                    ApplicationArea = All;
                    Caption = 'Check Post Code';
                    ToolTip = 'Specifies the post code that will be printed on the check.';
                }
                field("PTE Void Text"; Rec."PTE Void Text")
                {
                    ApplicationArea = All;
                    Caption = 'Check Void Text';
                    ToolTip = 'Specifies the void text that will be printed on the check.';
                }
                field("PTE 1st Signature Text"; Rec."PTE 1st Signature Text")
                {
                    ApplicationArea = All;
                    Caption = '1st Signature Text';
                    ToolTip = 'Specifies the 1st signature text that will be printed on the check.';
                }
                field("PTE 1st Signature Filename"; Rec."PTE 1st Signature Filename")
                {
                    ApplicationArea = All;
                    Caption = '1st Signature';
                    ToolTip = 'Specifies the 1st signature that will be printed on the check.';

                    trigger OnDrillDown()
                    begin
                        Rec.PTEDrillDownBlob(Rec.FieldNo("PTE 1st Signature"));
                    end;
                }
                field("PTE 1st Signature Logic"; Rec."PTE 1st Signature Logic")
                {
                    ApplicationArea = All;
                    Caption = '1st Signature Logic';
                    ToolTip = 'Specifies the logic that will be used to determine if the 1st signature will be printed on the check.';
                }
                field("PTE 2nd Signature Text"; Rec."PTE 2nd Signature Text")
                {
                    ApplicationArea = All;
                    Caption = '2nd Signature Text';
                    ToolTip = 'Specifies the 2nd signature text that will be printed on the check.';
                }
                field("PTE 2nd Signature Filename"; Rec."PTE 2nd Signature Filename")
                {
                    ApplicationArea = All;
                    Caption = '2nd Signature';
                    ToolTip = 'Specifies the 2nd signature that will be printed on the check.';

                    trigger OnDrillDown()
                    begin
                        Rec.PTEDrillDownBlob(Rec.FieldNo("PTE 2nd Signature"));
                    end;
                }
                field("PTE 2nd Signature Logic"; Rec."PTE 2nd Signature Logic")
                {
                    ApplicationArea = All;
                    Caption = '2nd Signature Logic';
                    ToolTip = 'Specifies the logic that will be used to determine if the 2nd signature will be printed on the check.';
                }
                field("PTE MICR Offset X"; Rec."PTE MICR Offset X")
                {
                    ApplicationArea = All;
                    Caption = 'MICR Offset X';
                    ToolTip = 'Specifies the MICR Offset X that will be used to position the MICR text. The MICR Offset starts from the top left hand corder of the MICR text box.';
                }
                field("PTE MICR Offset X1"; Rec."PTE MICR Offset X1")
                {
                    ApplicationArea = All;
                    Caption = 'MICR Offset X1';
                    ToolTip = 'Specifies the MICR Offset that will be used to position the first and second MICR text.';
                }
                field("PTE MICR Offset X2"; Rec."PTE MICR Offset X2")
                {
                    ApplicationArea = All;
                    Caption = 'MICR Offset X2';
                    ToolTip = 'Specifies the MICR Offset that will be used to position the second and third MICR text.';
                }
                field("PTE MICR Offset Y"; Rec."PTE MICR Offset Y")
                {
                    ApplicationArea = All;
                    Caption = 'MICR Offset Y';
                    ToolTip = 'Specifies the MICR Offset Y that will be used to position the MICR text. The MICR Offset starts from the top left hand corder of the MICR text box.';
                }
                field("PTE MICR Font Size"; Rec."PTE MICR Font Size")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the MICR font size.';
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        InitTxt: Label 'Click to import...';
    begin
        if not Rec.PTEBlobHasValue(Rec.FieldNo("PTE 1st Signature")) then
            Rec."PTE 1st Signature Filename" := InitTxt;

        if not Rec.PTEBlobHasValue(Rec.FieldNo("PTE 2nd Signature")) then
            Rec."PTE 2nd Signature Filename" := InitTxt;
    end;
}