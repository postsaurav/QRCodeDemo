report 50000 "SDH Sales Invoice"
{
    ApplicationArea = All;
    Caption = 'Sales Invoice';
    DefaultLayout = RDLC;
    RDLCLayout = './src/reports/SDHSalesInvoice.rdlc';
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(SalesInvoiceHeader; "Sales Invoice Header")
        {
            RequestFilterFields = "No.";
            column(Amount; Amount)
            {
            }
            column(No; "No.")
            {
            }
            column(LocationCode; "Location Code")
            {
            }
            column(OrderNo; "Order No.")
            {
            }
            column(PostingDate; "Posting Date")
            {
            }
            column(ExternalDocumentNo; "External Document No.")
            {
            }
            column(QRCode; "QR Code")
            {
            }
            trigger OnAfterGetRecord()
            var
                TempBlob: Codeunit "Temp Blob";
                RecordRef: RecordRef;
                QRText: Text[95];
            begin
                QRText := CreateQRCodeInput(SalesInvoiceHeader);
                CreateQRCode(QRText, TempBlob);
                RecordRef.GetTable(SalesInvoiceHeader);
                TempBlob.ToRecordRef(RecordRef, SalesInvoiceHeader.FieldNo("QR Code"));
                RecordRef.SetTable(SalesInvoiceHeader);
                CalcFields("QR Code");
            end;
        }
    }

    local procedure CreateQRCodeInput(SalesInvoiceHeader: Record "Sales Invoice Header") QRCodeInput: Text[95]
    begin
        QRCodeInput := CopyStr(SalesInvoiceHeader."No.", 1, 20) + Format(SalesInvoiceHeader."Posting Date")
                      + Format(SalesInvoiceHeader.Amount);
    end;

    local procedure CreateQRCode(QRCodeInput: Text[95]; var TempBLOB: Codeunit "Temp Blob")
    var
        EInvoiceObjectFactory: Codeunit "E-Invoice Object Factory";
    begin
        Clear(TempBLOB);
        EInvoiceObjectFactory.GetBarCodeBlob(QRCodeInput, TempBLOB);
    end;
}
