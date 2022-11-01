pageextension 80400 "PTE Bank Account" extends "Bank Account"
{
    layout
    {
        addlast()
        {
            group(SpearTech)
            {
                Caption = 'SpearTech';
                field("PTE Check Name",Rec."PTE Check Name") {ApplicationArea = All;
                    Caption = '';
                    ToolTip = '';
                }
                field("PTE Check Name 2",Rec."PTE Check Name 2") {ApplicationArea = All;
                    Caption = '';
                    ToolTip = '';
                }
                field("PTE Check Address",Rec."PTE Check Address") {ApplicationArea = All;
                    Caption = '';
                    ToolTip = '';
                }
                field("PTE Check Address 2",Rec."PTE Check Address 2") {ApplicationArea = All;
                    Caption = '';
                    ToolTip = '';
                }
                field("PTE Check City",Rec."PTE Check City") {ApplicationArea = All;
                    Caption = '';
                    ToolTip = '';
                }
                field("PTE Check Country/Region Code",Rec."PTE Check Country/Region Code") {ApplicationArea = All;
                    Caption = '';
                    ToolTip = '';
                }
                field("PTE Check Post Code",Rec."PTE Check Post Code") {ApplicationArea = All;
                    Caption = '';
                    ToolTip = '';
                }
                field("PTE Void Text",Rec."PTE Void Text") {ApplicationArea = All;
                    Caption = '';
                    ToolTip = '';
                }
                field("PTE 1st Sigature Text",Rec."PTE 1st Sigature Text") {ApplicationArea = All;
                    Caption = '';
                    ToolTip = '';
                }
                field("PTE 1st Sigature Filename",Rec."PTE 1st Sigature Filename") {ApplicationArea = All;
                    Caption = '';
                    ToolTip = '';

                    trigger OnDrillDown()
                    begin
                        Rec.DrillDownBlob(Rec.FieldNo("PTE 1st Sigature"));
                    end;
                }
                field("PTE 1st Sigature Logic",Rec."PTE 1st Sigature Logic") {ApplicationArea = All;
                    Caption = '';
                    ToolTip = '';
                }
                field("PTE 2nd Sigature Text",Rec."PTE 2nd Sigature Text") {ApplicationArea = All;
                    Caption = '';
                    ToolTip = '';
                }
                field("PTE 2nd Sigature Filename",Rec."PTE 2nd Sigature Filename") {ApplicationArea = All;
                    Caption = '';
                    ToolTip = '';

                    trigger OnDrillDown()
                    begin
                        Rec.DrillDownBlob(Rec.FieldNo("PTE 2nd Sigature"));
                    end;
                }
                field("PTE 2nd Sigature Logic",Rec."PTE 2nd Sigature Logic") {ApplicationArea = All;
                    Caption = '';
                    ToolTip = '';
                }
                field("PTE MICR Offset X",Rec."PTE MICR Offset X") {ApplicationArea = All;
                    Caption = '';
                    ToolTip = '';
                }
                field("PTE MICR Offset Y",Rec."PTE MICR Offset Y") {ApplicationArea = All;
                    Caption = '';
                    ToolTip = '';
                }
            }
        }
    }
}