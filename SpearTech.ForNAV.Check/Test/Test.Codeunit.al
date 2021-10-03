codeunit 80449 "PTE Test Interface"
{
    Subtype = Test;

    [Test]
    procedure TestInterface()
    var
        PaymentInterface: Record "PTE Payment Interface";
        GLEntry: Record "G/L Entry";
        VendLedEnt: Record "Vendor Ledger Entry";
        PDFFile: Record "PTE Check Data";
        TestLib: Codeunit "PTE Test Library";
        is: InStream;
        Base64Conv: Codeunit "Base64 Convert";
        Base64Text: Text;
    begin
        PaymentInterface."Vendor No." := '10000';
        PaymentInterface."Document No." := 'TEST01';
        PaymentInterface."External Document No." := 'EXTTEST01';
        PaymentInterface."Amount (USD)" := 100;
        PaymentInterface.Description := 'Payment Description';
        PaymentInterface.ProcessPaymentInterface(TestLib.GetSampleBase64PDF());

        GLEntry.SetRange("Document No.", PaymentInterface."Document No.");
        GLEntry.SetRange(Amount, PaymentInterface."Amount (USD)");
        GLEntry.FindFirst();
        GLEntry.TestField("External Document No.", PaymentInterface."External Document No.");

        VendLedEnt.SetRange("Document No.", PaymentInterface."Document No.");
        VendLedEnt.FindFirst();
        VendLedEnt.CalcFields("Original Amount");
        VendLedEnt.TestField("Original Amount", PaymentInterface."Amount (USD)");

        PDFFile.Get(PaymentInterface."Document No.");
        PDFFile.CalcFields(PDF);
        PDFFile.PDF.CreateInStream(is);
        is.ReadText(Base64Text);
        Base64Text := Base64Conv.ToBase64(Base64Text);
        if Base64Text <> TestLib.GetSampleBase64PDF() then
            Error('Something is wrong with the base64 stuff');

    end;


}