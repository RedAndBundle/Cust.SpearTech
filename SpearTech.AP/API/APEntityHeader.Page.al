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
    ChangeTrackingAllowed = true;

    // http://bc220-us:7048/bc/api/speartech/ap/v2.0/companies(17bbc8b0-cc08-ee11-8f7b-6045bdc8a215)/apHeaders?tenant=default
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

    // http://bc220-us:7048/bc/api/speartech/ap/v2.0/companies(17bbc8b0-cc08-ee11-8f7b-6045bdc8a215)/apHeaders(ecca1e29-8815-ee11-9e03-a6b3ed45dbcc)
    trigger OnFindRecord(Which: Text): Boolean
    begin
        exit(Rec.GetFromSystemId(Rec.GetFilter(SystemId)));
    end;

    // http://bc220-us:7048/bc/api/speartech/ap/v2.0/companies(17bbc8b0-cc08-ee11-8f7b-6045bdc8a215)/apHeaders(ecca1e29-8815-ee11-9e03-a6b3ed45dbcc)/Microsoft.NAV.post?tenant=default
    [ServiceEnabled]
    [Scope('Cloud')]
    procedure Post(var ActionContext: WebServiceActionContext)
    begin
        Rec.Post();
    end;
}
