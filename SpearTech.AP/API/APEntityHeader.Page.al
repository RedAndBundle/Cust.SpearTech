Page 80501 "PTEAP API AP Header"
{
    DelayedInsert = true;
    DeleteAllowed = false;
    EntityName = 'apHeader';
    EntitySetName = 'apHeaders';
    ODataKeyFields = SystemId;
    PageType = API;
    APIPublisher = 'speartech';
    APIGroup = 'ap';
    APIVersion = 'v2.0';
    SourceTable = "PTEAP API AP Header";
    SourceTableTemporary = true;

    Extensible = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(id; Rec.SystemId) { ApplicationArea = Basic, Suite; }
                field(selltoCustomerNo; Rec."Sell-to Customer No.") { ApplicationArea = Basic, Suite; }
                field(billToCustomerNo; Rec."Bill-To Customer No.") { ApplicationArea = Basic, Suite; }
                field(claimNumber; Rec."Claim Number") { ApplicationArea = Basic, Suite; }
                field(invoiceType; Rec."Invoice Type") { ApplicationArea = Basic, Suite; }
                field(claimantName; Rec."Claimant Name") { ApplicationArea = Basic, Suite; }
                field(ssn; Rec.SSN) { ApplicationArea = Basic, Suite; }
                field(dob; Rec.DOB) { ApplicationArea = Basic, Suite; }
                field(claimsManager; Rec."Claims Manager") { ApplicationArea = Basic, Suite; }
                field(referralDate; Rec."Referral Date") { ApplicationArea = Basic, Suite; }
                field(accidentDate; Rec."Accident Date") { ApplicationArea = Basic, Suite; }
                field(result; Result) { ApplicationArea = Basic, Suite; }
            }
            part(apLines; "PTEAP API AP Line")
            {
                EntityName = 'apLine';
                EntitySetName = 'apLines';
                SubPageLink = "Claim Number" = field("Claim Number"), "Invoice Type" = field("Invoice Type");
            }
        }
    }

    var
        Result: Text;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        Setup: Record "PTEAP Spear AP Setup";
    begin
        Rec.TestField("Sell-to Customer No.");
        Rec.TestField("Claim Number");
        Setup.Get();
        Setup.TestField("Item Template");
        Result := Rec.ProcessAPInterface();
    end;

    trigger OnFindRecord(Which: Text): Boolean
    begin
        Message('hi');
        Rec.Init();
        Rec."Claim Number" := Rec.GetFilter("Claim Number");
        Rec."Sell-to Customer No." := '10000';
        Rec.Insert();
        exit(true);
    end;

    trigger OnAfterGetRecord()
    begin
        // Message('hi');
    end;
}
