import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ha_angricola/helper/colorsUI.dart';
import 'package:ha_angricola/helper/helper.dart';
import 'package:ha_angricola/main.dart';
import 'package:ha_angricola/models/crudmodelrequest.dart';
import 'package:ha_angricola/models/product.dart';
import 'package:ha_angricola/models/request.dart';
import 'package:ha_angricola/models/user.dart';
import 'package:ha_angricola/service/authentication.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:open_file/open_file.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart' ;


Color companyColor =Color(0xFFA0867C);


class CreatePdfOrImageStatefulWidget extends StatefulWidget {

  CreatePdfOrImageStatefulWidget({Key key, this.productDetails, this.amount, this.user, this.file, this.auth, this.userId}) : super(key: key);
  final List<Product> productDetails;
  final double amount;
  final User user;
   File file;
  final BaseAuth auth;
  final String userId;


  @override
  _CreatePdfState createState() => _CreatePdfState();
}

class _CreatePdfState extends State<CreatePdfOrImageStatefulWidget> {


  GlobalKey globalKey = GlobalKey();
  bool _isLoading=false;
  bool _isErrorMessage=false;
  bool granted=false;
  int originalSize = 800;
  Image image;
  File _file, _fileExtern;
  String downloadUrl;



  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  bool isPdfButton=true;
  double elevation=0.0;

  Map<Permission, PermissionStatus> statuses;

  @override
  void initState()  {
    isPdfButton=true;
    elevation=0.0;
    downloadUrl=null;

    _fileExtern=widget.file==null?null:widget.file;

    super.initState();
  }

  checkPermission() async
  {
    statuses = await [
      Permission.storage,
      Permission.photos,
      Permission.accessMediaLocation,
      Permission.mediaLibrary,
    ].request();



    if (statuses!=null) {
      if(statuses[Permission.storage].isGranted) {
        String path= await capturePng();

        if(path!=null){
          OpenFile.open(path);
          navigatorToHome();
        }

      }
    }
  }





  @override
  Widget build(BuildContext context) {
    //SimplePermissions.requestPermission(Permission.WriteExternalStorage);
    CRUDModelRequest crudRequest = new CRUDModelRequest(isError: (value){
        setState(() {
          _isErrorMessage=value;
        });
    });
    return Scaffold(
      appBar: AppBar(
        title: Text('Factura'),
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back),
        ),
      ),
      body: RepaintBoundary(
        key: globalKey,
        child: ListView(

          children: <Widget>[
            Container(
              padding: EdgeInsets.all(8.0),
              color:ColorsUI.headerColor1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('HÁ-Angrícola', style: TextStyle(color: Colors.white, fontSize: 16.0),),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20.0, top: 4.0),
                        child: Text('haagricola@gmail.com', style: TextStyle(color: Colors.white, fontSize: 12.0),),
                      ),
                    ],
                  )
                  ,
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                        child: Text('Montante', style: TextStyle(color: Colors.white)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('${Helper.numberFormat(widget.amount)} AKZ', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 4.0, left: 8.0),
              child: Text('Dados do Cliente:', style: TextStyle(fontWeight: FontWeight.bold),),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 4.0, left: 8.0),
              child: Text("${widget.user.firstName}", style: TextStyle(color: Colors.black),),
            ),
            Container(
                padding: const EdgeInsets.only(top: 4.0, bottom: 4.0, left: 8.0),
                child: Text('${widget.user.location}', style: TextStyle(color: Colors.black))),
            Container(
                padding: const EdgeInsets.only(top: 4.0, bottom: 4.0, left: 8.0),
                   child:  Text('${widget.user.email}', style: TextStyle(color: Colors.black))
                ),
            Container(
                padding: const EdgeInsets.only(top: 4.0, bottom: 4.0, left: 8.0),
                child: Align(
                  alignment: Alignment.bottomRight,
                    child: Text('${Helper.DateNow()}', style: TextStyle(color: Colors.black)))),
           _showCircularProgress(),
            Container(
              margin: EdgeInsets.only(top: 16.0,left: 2.0, right: 2.0, bottom: 8.0 ),
              child: Table(
                children: getTableRow(),
              ),
            ),

          ],
        ),
      ),
      bottomNavigationBar:  Container(
        margin: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0,bottom: 8.0 ),
        child: Card(
          child: Row(
            children: <Widget>[
              !Platform.isIOS ?
          GestureDetector(
            child: Container(
            width: 155,
            decoration: BoxDecoration(
              color:!isPdfButton?ColorsUI.primaryColor: Colors.white,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(5.0),
                  topLeft: Radius.circular(5.0)),
            ),
            height: 50.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child:
              Center(
                child: Text('GERAR PDF',
                  style: TextStyle(color: Colors.black),),
              ),
            ),
          ),
          onTap: () async{
              setState(() {
                isPdfButton=false;
                _isLoading=true;
              });
            downloadUrl=  await  CRUDModelRequest.uploadFilePreform(widget.user.email, _fileExtern);
            setState(() {

                if(downloadUrl!=null)
                  {
                    downloadUrl=downloadUrl;
                  }
            });
              Request request =new Request(amount: widget.amount, user: widget.user, products: widget.productDetails, date: Helper.DateNow(), img:downloadUrl );
            crudRequest.addRequest(request);
            if(!_isErrorMessage){

              await generateInvoice();
               navigatorToHome();
            }

          },
        ):  Container(width:0.0, height:0.0),
              Expanded(
                child: GestureDetector(
                  child: Container(
                    width: 155,
                    decoration: BoxDecoration(
                      color:isPdfButton?ColorsUI.primaryColor:  Colors.white,
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(5.0),
                          topRight: Radius.circular(5.0)),
                    ),
                    height: 50.0,
                    child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child:
                        Center(child: Text('GERAR IMAGEM', style: TextStyle(fontSize: 16.0, color: Colors.black)))
                    ),
                  ),
                  onTap: () async{
                    setState(() {
                      _isLoading=true;
                      isPdfButton=true;
                    });
                    if(widget.file!=null){
                      downloadUrl=  await  CRUDModelRequest.uploadFilePreform(widget.user.email, _fileExtern);
                    }
                    setState(() {
                      if(downloadUrl!=null)
                      {
                        downloadUrl=downloadUrl;
                      }
                      // Helper.showCircularProgress(_isLoading);
                    });
                    Request request =new Request(amount: widget.amount, user: widget.user, products: widget.productDetails, date: Helper.DateNow(), img:downloadUrl );
                    crudRequest.addRequest(request);
                    if(!_isErrorMessage){
                      checkPermission();
                    }

                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void navigatorToHome() {
   /* int count=1;
    Navigator.popUntil(context, (route) {
      return count++==3;
    }
    );*/
   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>
       HomePage(clean: true,auth: widget.auth, userId: widget.userId,)), ModalRoute.withName('/second'));
  }

  Future<String> capturePng() async {
    double pixelRatio = originalSize / MediaQuery.of(context).size.width;
    RenderRepaintBoundary boundary = globalKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();

    final result = await ImageGallerySaver.saveImage(pngBytes);
    print(result);

    List<String> str=Helper.DateNow().split(" ");
    List<String> str1=str[1].split(",");

    final formName="product_${str[0]}_${str1[0]}_${str[2]}.png";

    //Get the storage folder location using path_provider package.
    var directory = await getApplicationDocumentsDirectory();
    var path = directory.path;

    //The pattern way to give path name
    // File file = File('$path/product.pdf');

    setState(() {
      _file = File('$path/$formName');
    });
    await _file.writeAsBytes(pngBytes);
    print('$path/$formName');

    _isLoading=true;

    //Upload File to Firebase Storage
    CRUDModelRequest.uploadFile(formName, _file);


    return '$path/$formName';

  }

  Future<void> generateInvoice() async {
    //Create a PDF document.
    final PdfDocument document = PdfDocument();
    //Add page to the PDF
    final PdfPage page = document.pages.add();
    //Get page client size
    final Size pageSize = page.getClientSize();
    //Draw rectangle
    page.graphics.drawRectangle(
        bounds: Rect.fromLTWH(0, 0, pageSize.width, pageSize.height),
        pen: PdfPen(PdfColor(142, 170, 219, 255)));
    //Generate PDF grid.
    final PdfGrid grid = getGrid();
    //Draw the header section by creating text element
    final PdfLayoutResult result = drawHeader(page, pageSize, grid);
    //Draw grid
    drawGrid(page, grid, result);
    //Add invoice footer
    drawFooter(page, pageSize);
    //Save and launch the document
    final List<int> bytes = document.save();
    //Dispose the document.
    document.dispose();
    //Get the storage folder location using path_provider package.
    var directory = await getApplicationDocumentsDirectory();
    var path = directory.path;

    List<String> str=Helper.DateNow().split(" ");
    List<String> str1=str[1].split(",");
    final formName="product${str[0]}_${str1[0]}_${str[2]}.pdf";

      File file = File('$path/$formName');
      file.writeAsBytes(bytes);
      CRUDModelRequest.uploadFile(formName, file);

      //Launch the file (used open_file package)
      OpenFile.open('$path/$formName');


  }
  

  //Draws the invoice header
  PdfLayoutResult drawHeader(PdfPage page, Size pageSize, PdfGrid grid) {
    //Draw rectangle
    page.graphics.drawRectangle(
        brush: PdfSolidBrush(PdfColor(91, 126, 215, 255)),
        bounds: Rect.fromLTWH(0, 0, pageSize.width - 115, 90));
    //Draw string
    page.graphics.drawString(
        'HA-AGRÍCOLA\r\n\r\n haagricola@gmail.com', PdfStandardFont(PdfFontFamily.helvetica, 30),
        brush: PdfBrushes.white,
        bounds: Rect.fromLTWH(25, 0, pageSize.width - 115, 90),
        format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));

    page.graphics.drawRectangle(
        bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 90),
        brush: PdfSolidBrush(PdfColor(65, 104, 205)));

    page.graphics.drawString('\$' + getTotalAmount(),
        PdfStandardFont(PdfFontFamily.helvetica, 18),
        bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 100),
        brush: PdfBrushes.white,
        format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            lineAlignment: PdfVerticalAlignment.middle));

    final PdfFont contentFont = PdfStandardFont(PdfFontFamily.helvetica, 9);
    //Draw string
    page.graphics.drawString('Montante', contentFont,
        brush: PdfBrushes.white,
        bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 33),
        format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            lineAlignment: PdfVerticalAlignment.bottom));
    //Create data foramt and convert it to text.
    final DateFormat format = DateFormat.yMMMMd('en_US');
    final String invoiceNumber =
        'Número da HA-Agrícola: 926 292 825 / 940 116 796\r\n\r\nData: ' +
            format.format(DateTime.now());
    final Size contentSize = contentFont.measureString(invoiceNumber);
     String address =
        '${widget.user.firstName}: \r\n\r\n${widget.user.location}, \r\n\r\nAngola, Luanda';

    PdfTextElement(text: invoiceNumber, font: contentFont).draw(
        page: page,
        bounds: Rect.fromLTWH(pageSize.width - (contentSize.width + 30), 120,
            contentSize.width + 30, pageSize.height - 120));

    return PdfTextElement(text: address, font: contentFont).draw(
        page: page,
        bounds: Rect.fromLTWH(30, 120,
            pageSize.width - (contentSize.width + 30), pageSize.height - 120));
  }

  //Draws the grid
  void drawGrid(PdfPage page, PdfGrid grid, PdfLayoutResult result) {
    Rect totalPriceCellBounds;
    Rect quantityCellBounds;
    //Invoke the beginCellLayout event.
    grid.beginCellLayout = (Object sender, PdfGridBeginCellLayoutArgs args) {
      final PdfGrid grid = sender as PdfGrid;
      if (args.cellIndex == grid.columns.count - 1) {
        totalPriceCellBounds = args.bounds;
      } else if (args.cellIndex == grid.columns.count - 2) {
        quantityCellBounds = args.bounds;
      }
    };
    //Draw the PDF grid and get the result.
    result = grid.draw(
        page: page, bounds: Rect.fromLTWH(0, result.bounds.bottom + 40, 0, 0));

    //Draw grand total.
    page.graphics.drawString('Total ',
        PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(
            quantityCellBounds.left,
            result.bounds.bottom + 10,
            quantityCellBounds.width,
            quantityCellBounds.height));
    page.graphics.drawString(getTotalAmount(),
        PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(
            totalPriceCellBounds.left,
            result.bounds.bottom + 10,
            totalPriceCellBounds.width,
            totalPriceCellBounds.height));
  }

  //Draw the invoice footer data.
  void drawFooter(PdfPage page, Size pageSize) {
    final PdfPen linePen =
        PdfPen(PdfColor(142, 170, 219, 255), dashStyle: PdfDashStyle.custom);
    linePen.dashPattern = <double>[3, 3];
    //Draw line
    page.graphics.drawLine(linePen, Offset(0, pageSize.height - 100),
        Offset(pageSize.width, pageSize.height - 100));

    const String footerContent =
        'HA-agrícola\r\n\r\n Localização: Luanda,\r\n\r\nQualquer questão liga para 926 292 825 / 940 116 796';

    //Added 30 as a margin for the layout
    page.graphics.drawString(
        footerContent, PdfStandardFont(PdfFontFamily.helvetica, 9),
        format: PdfStringFormat(alignment: PdfTextAlignment.right),
        bounds: Rect.fromLTWH(pageSize.width - 30, pageSize.height - 70, 0, 0));
  }

  //Create PDF grid and return
  PdfGrid getGrid() {
    //Create a PDF grid
    final PdfGrid grid = PdfGrid();
    //Specify the columns count to the grid.
    grid.columns.add(count: 5);
    //Create the header row of the grid.
    final PdfGridRow headerRow = grid.headers.add(1)[0];
    //Set style
    headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(68, 114, 196));
    headerRow.style.textBrush = PdfBrushes.white;
    headerRow.cells[0].value = 'ID do Producto';
    headerRow.cells[0].stringFormat.alignment = PdfTextAlignment.center;
    headerRow.cells[1].value = 'Nome do Producto';
    headerRow.cells[2].value = 'Preço';
    headerRow.cells[3].value = 'Quantidade';
    headerRow.cells[4].value = 'Total';

    for(Product product in widget.productDetails){

      addProducts(product, grid);
    }

    grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable4Accent5);
    //Set gird columns width
    grid.columns[1].width = 200;
    for (int i = 0; i < headerRow.cells.count; i++) {
      headerRow.cells[i].style.cellPadding =
          PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
    }
    for (int i = 0; i < grid.rows.count; i++) {
      final PdfGridRow row = grid.rows[i];
      for (int j = 0; j < row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j];
        if (j == 0) {
          cell.stringFormat.alignment = PdfTextAlignment.center;
        }
        cell.style.cellPadding =
            PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
      }
    }
    return grid;
  }


  //Create and row for the grid.
  void addProducts(Product product, PdfGrid grid) {
    PdfGridRow row = grid.rows.add();
    row.cells[0].value = product.id;
    row.cells[1].value = product.name;
    row.cells[2].value = product.price.toString();
    row.cells[3].value =product.quantity.toString();
    row.cells[4].value = product.amount.toString();
  }

  //Get the total amount.
  String getTotalAmount() {

   return Helper.numberFormat(widget.amount) +' AKZ';
   // return widget.amount;
  }

  List<TableRow> getTableRow()
  {
    List<Product> product = widget.productDetails;



    List<TableRow> tableRow=new List();
    tableRow.add(
        TableRow(
        decoration: BoxDecoration(
          color: ColorsUI.headerColor1,
        ),
        children: [
          TableCell(
            child: Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 4.0,right: 4.0,left: 4.0,),
              child: Text("ID", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12.0 ),),
            ),
          ),
          TableCell(
            child: Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 4.0,left: 4.0, right: 4.0),
              child: Text("Producto", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12.0),),
            ),
          ),
          TableCell(
            child: Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 4.0,left: 4.0, right: 4.0),
              child: Text("Preco", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold , fontSize: 12.0) ),
            ),
          ),
          TableCell(
            child: Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 4.0,left: 4.0, right: 4.0),
              child: Text("Quantidade", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 12.0),),
            ),
          ),
          TableCell(
            child: Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 4.0),
              child: Text("Total", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold , fontSize:12.0 ),),
            ),
          ),
        ]));

    for(int iterator=0; iterator<product.length; iterator++)
    {
      Color color=(iterator%2==0)?Colors.white:ColorsUI.headerColor2;

      tableRow.add( TableRow(
          decoration: BoxDecoration(
            color: color,
          ),
          children: [
            TableCell(
              child: Padding(
                padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
                child: Container(
                  margin: EdgeInsets.only(top: 2.0, left: 4.0, right: 4.0),
                    child: Text("${product[iterator].id},", style: TextStyle(color: Colors.black, fontSize: 12.0),)),
              ),
            ),
            TableCell(
              child: Padding(
                padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
                child: Container(
                    padding: EdgeInsets.only(top: 2.0, left: 4.0, right: 4.0),
                    child: Text("${product[iterator].name}",style: TextStyle(color: Colors.black, fontSize: 12.0))),
              ),
            ),
            TableCell(
              child: Padding(
                padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
                child: Container(
                    padding: EdgeInsets.only(top: 2.0, left: 4.0, right: 4.0),
                    child: Text("${Helper.numberFormat(product[iterator].price)} AKZ", style: TextStyle(color: Colors.black, fontSize: 12.0))),
              ),
            ),
            TableCell(
              child: Padding(
                padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
                child: Container(
                    padding: EdgeInsets.only(top: 2.0, left: 4.0, right: 4.0),
                    child: Text("${product[iterator].quantity}", style: TextStyle(color: Colors.black, fontSize: 12.0)), ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
                child: Container(
                    padding: EdgeInsets.only(top: 2.0),
                    child: Text("${Helper.numberFormat(product[iterator].amount)} AKZ", style: (TextStyle(color: Colors.black, fontSize: 12.0)),
              ),
            ),),)
          ]));
    }

    return tableRow;

  }

}
