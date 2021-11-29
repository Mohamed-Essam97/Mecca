import 'package:Mecca/core/models/branch.dart';
import 'package:Mecca/core/models/status.dart';
import 'package:Mecca/core/services/api/api.dart';
import 'package:Mecca/core/services/api/http_api.dart';
import 'package:Mecca/core/services/auth/authentication_service.dart';
import 'package:Mecca/core/services/localization/localization.dart';
import 'package:Mecca/core/services/preference/preference.dart';
import 'package:Mecca/ui/pages/user/Home_Page/payment_success.dart';
import 'package:Mecca/ui/payment/payment.dart';
import 'package:Mecca/ui/routes/route.dart';
import 'package:Mecca/ui/styles/colors.dart';
import 'package:Mecca/ui/widgets/buttons/normal_button.dart';
import 'package:Mecca/ui/widgets/loading.dart';
import 'package:Mecca/ui/widgets/reactive_widgets.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:ui_utils/ui_utils.dart';
import 'package:Mecca/ui/widgets/error.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:hijri_picker/hijri_picker.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:hijri_picker/hijri_picker.dart';
import 'package:hijri/digits_converter.dart';
import 'package:hijri/hijri_array.dart';
import 'package:hijri/hijri_calendar.dart';

class RequestServicePage extends StatelessWidget {
  DateTime date;
  String price;
  // Future<void> _selectDate(
  //     BuildContext context, RequestServicePageModel model) async {
  //   final DateTime picked = await showDatePicker(
  //       context: context,
  //       initialDate: selectedDate,
  //       firstDate: DateTime.now(),
  //       lastDate: DateTime(2101));
  //   if (picked != null && picked != selectedDate) selectedDate = picked;
  //   model.getPeice(selectedDate.millisecondsSinceEpoch.toString(), serviceid);
  //   model.setState();
  // }
  var selectedDate = new HijriCalendar.now();

  Future<void> _selectDate(BuildContext context, model) async {
    final HijriCalendar picked = await showHijriDatePicker(
      context: context,
      initialDate: selectedDate,
      lastDate: new HijriCalendar()
        ..hYear = 1445
        ..hMonth = 9
        ..hDay = 25,
      firstDate: new HijriCalendar()
        ..hYear = 1438
        ..hMonth = 12
        ..hDay = 25,
      initialDatePickerMode: DatePickerMode.day,
    );
    if (picked != null) {
      selectedDate = picked;
      print(selectedDate.toFormat("MMMM dd yyyy")); //Ramadan 14 1439
      print(selectedDate.hijriToGregorian(selectedDate.hYear,
          selectedDate.hMonth, selectedDate.hDay)); //Ramadan 14 1439

      date = selectedDate.hijriToGregorian(
          selectedDate.hYear, selectedDate.hMonth, selectedDate.hDay);
      var timeStamp = date.millisecondsSinceEpoch;

      print(date.millisecondsSinceEpoch);
      model.getPeice(timeStamp, serviceid);
      model.form.control('executionTime').updateValue(timeStamp.toString());
    } else {
      UI.toast("please select date");
    }

    model.setState();
  }

  final String servicetitle;
  final String serviceprice;
  final String serviceid;
  RequestServicePage({this.servicetitle, this.serviceprice, this.serviceid});
  @override
  Widget build(BuildContext context) {
    // navigate(context);
    final locale = AppLocalizations.of(context);
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    bool loading = false;
    bool isDark = Preference.getBool(PrefKeys.isDark);

    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return BaseWidget<RequestServicePageModel>(
        initState: (m) => WidgetsBinding.instance.addPostFrameCallback((_) {
              m.get_status();
              m.getAllBranches();
            }),
        model: RequestServicePageModel(
            api: Provider.of<Api>(context),
            auth: Provider.of(context),
            serviceid: serviceid,
            serviceprice: serviceprice,
            servicetitle: servicetitle,
            context: context),
        builder: (context, model, _child) => Scaffold(
              backgroundColor: AppColors.getDarkLightBackGround(),
              appBar: AppBar(
                  elevation: 0,
                  title: Text("${servicetitle}"),
                  centerTitle: true,
                  backgroundColor: AppColors.primary,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  )),
              body: Stack(
                children: [
                  loading || model.status.isEmpty
                      ? Center(
                          child: Loading(
                            color: AppColors.primary,
                            size: 50.0,
                          ),
                        )
                      : SizedBox(),
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ReactiveForm(
                        formGroup: model.form,
                        child: Container(
                          color: Colors.transparent,
                          child: Container(
                            decoration: BoxDecoration(
                                color:
                                    AppColors.getDarkLightSecondaryBackGround(),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            child: Column(
                              children: <Widget>[
                                //SizedBox(height: screenHeight*0.01,),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Information of the person",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: screenHeight * 0.03,
                                ),

                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ReactiveField(
                                    borderColor: Colors.grey,
                                    enabledBorderColor: Colors.grey,
                                   

                                    // hintColor: Colors.grey[100],
                                    type: ReactiveFields.TEXT,
                                    controllerName: 'name',
                                    label: locale.get('Name') ?? 'Name',
                                  ),
                                ),
                                SizedBox(
                                  height: screenHeight * 0.01,
                                ),

                                Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Text("${selectedDate}"
                                                  .split(' ')[0]),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              InkWell(
                                                  onTap: () {
                                                    _selectDate(context, model);
                                                    print(model.form
                                                        .control(
                                                            'executionTime')
                                                        .value);
                                                  },
                                                  child: Icon(Icons.date_range))
                                            ],
                                          )),
                                    ),
                                    // Expanded(
                                    //   child: Padding(
                                    //       padding: const EdgeInsets.all(8.0),
                                    //       child: Row(
                                    //         children: [
                                    //           Text("${selectedDate2.toLocal()}"
                                    //               .split(' ')[0]),
                                    //           SizedBox(
                                    //             width: 10,
                                    //           ),
                                    //           InkWell(
                                    //               onTap: () {
                                    //                 _selectDate2(
                                    //                     context, model);
                                    //                 model.form
                                    //                     .control("to")
                                    //                     .updateValue(
                                    //                         selectedDate2
                                    //                             .toLocal()
                                    //                             .toString());
                                    //               },
                                    //               child: Icon(Icons.date_range))
                                    //         ],
                                    //       )),
                                    // ),
                                  ],
                                ),
                                SizedBox(
                                  height: screenHeight * 0.01,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ReactiveField(
                                    borderColor: Colors.grey,
                                    enabledBorderColor: Colors.grey,
                                    hintColor: Colors.grey[100],
                                    
                                    type: ReactiveFields.TEXT,
                                    keyboardType: TextInputType.number,
                                    controllerName: 'numberOfUtilities',
                                    label: locale.get('Number of Services') ??
                                        'Number of Services',
                                  ),
                                ),

                                SizedBox(
                                  height: screenHeight * 0.01,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ReactiveDropdownField(
                                      decoration: InputDecoration(
                                        // labelStyle: TextStyle(color: Colors.blue),
                                        // filled: filled,
                                        fillColor: isDark
                                            ? Color(0xff141D26)
                                            : Colors.white,
                                        focusedBorder: !isDark
                                            ? OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                borderSide: BorderSide(
                                                    color: Colors.red,
                                                    width: 1.0),
                                              )
                                            : null,
                                        filled: isDark ? true : false,
                                        enabledBorder: !isDark
                                            ? OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                borderSide: BorderSide(
                                                  color: Colors.grey[200],
                                                  width: 1.0,
                                                ),
                                              )
                                            : null,

                                        // fillColor: Colors.white,
                                      ),
                                      formControlName: "personStatus",
                                      hint: Text(
                                        locale.get('Status') ?? 'Status',
                                      ),
                                      items: model.status),
                                ),
                                SizedBox(
                                  height: screenHeight * 0.01,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Checkbox(
                                      value: model.active,
                                      activeColor: AppColors.primary,
                                      onChanged: (value) {
                                        model.active = value;
                                        model.setState();
                                      },
                                    ),
                                    Text(locale.get("Cash") ?? "Cash")
                                  ],
                                ),
                                model.active
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ReactiveDropdownField(
                                            decoration: InputDecoration(
                                              filled: true,
                                            ),
                                            formControlName: "branch._id",
                                            hint: Text(
                                              locale.get('Branch') ?? 'Branch',
                                            ),
                                            items: model.branche),
                                      )
                                    : SizedBox(),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ReactiveField(
                                    borderColor: Colors.grey,
                                    enabledBorderColor: Colors.grey,
                                    type: ReactiveFields.HUGE_TEXT,
                                    label: "Other Details",
                                    keyboardType: TextInputType.text,
                                    controllerName: 'otherDetails',
                                  ),
                                ),

                                SizedBox(
                                  height: screenHeight * 0.01,
                                ),

                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: NormalButton(
                                    onPressed: model.form.valid
                                        ? () async {
                                            // if (model.form.valid) {
                                            //   print(model.form.value);
                                            //   model.postrequest();
                                            // }
                                            if (model.form.valid) {
                                              if (model.active) {
                                                model.postrequest();
                                              } else {
                                                UI.push(
                                                    context,
                                                    PaymentPage(
                                                      isCash: model.active,
                                                      servicename: servicetitle,
                                                      serviceprice:
                                                          model.serviceprice,
                                                      numberofservices: model
                                                          .form
                                                          .control(
                                                              'numberOfUtilities')
                                                          .value,
                                                      formdata:
                                                          model.form.value,
                                                    ));
                                              }
                                            }
                                          }
                                        : null,
                                    text: "Request",
                                    color: model.form.valid
                                        ? AppColors.primary
                                        : Colors.grey,
                                    raduis: 5,
                                  ),
                                ),

                                SizedBox(
                                  height: screenHeight * 0.02,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ));
  }
}

class RequestServicePageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;
  FormGroup form;
  var serviceid;
  var checkedValue = false;
  var serviceprice;
  String servicetitle;
  bool agree = true;
  String usertype;
  List<DropdownMenuItem> status = [];
  List<DropdownMenuItem> branche = [];
  List<Status> all_stat;

  RequestServicePageModel(
      {NotifierState state,
      this.api,
      this.auth,
      this.context,
      this.serviceid,
      this.servicetitle,
      this.serviceprice})
      : super(state: state) {
    form = FormGroup({
      'name': FormControl(
        validators: [Validators.required],
      ),
      'executionTime': FormControl<String>(
        value: DateTime.now().toString(),
        validators: [Validators.required],
      ),
      'numberOfUtilities': FormControl(
        validators: [Validators.required],
      ),
      'otherDetails': FormControl(),
      'utility': FormControl(value: {"_id": "$serviceid"}),
      'requestBy': FormControl(value: {"_id": "${auth.user.user.sId}"}),
      'personStatus': FormControl(validators: [Validators.required]),
      'requestUtilityStatus': FormControl(value: "pending"),
      'isCashed': FormControl(value: active),
      'branch': FormGroup({
        '_id': FormControl(),
      })
    });
  }
  get_status() async {
    status.clear();
    setBusy();

    var res = await api.getstats(context);
    res.fold((error) {
      UI.toast(error.toString());
      setError();
    }, (data) {
      setIdle();
      all_stat = data.map<Status>((item) => Status.fromJson(item)).toList();
    });

    all_stat != null ? setIdle() : setError();
    print(all_stat);
    all_stat.forEach((element) {
      status.add(DropdownMenuItem<String>(
        value: "${element.sId}",
        child: new Text("${element.name}"),
      ));
    });
    setState();
  }

  postrequest() async {
    var res = await api.postRequest(context, body: form.value);
    res.fold((error) {
      ErrorDialog(error: error, context: context).showError();
      return false;
    }, (data) {
      UI.push(context, PaymentsuccessPage());
      UI.toast("Added Succesfully");

      return true;
    });
  }

  bool active = false;
  String price;

  getPeice(date, utilityId) async {
    var res = await api.getAllPrice(context, {"date": date}, utilityId);
    res.fold((error) {
      UI.toast(error.toString());
    }, (data) {
      price = data.toString();
      // UI.toast(data.toString());
    });
  }

  List<Branch> branches;
  getAllBranches() async {
    setBusy();
    var res = await api.getAllBranches(context);
    res.fold((error) {
      UI.toast(error.toString());
      setError();
    }, (data) {
      branches = data.map<Branch>((item) => Branch.fromJson(item)).toList();
      setIdle();
    });

    branches.forEach((element) {
      branche.add(DropdownMenuItem<String>(
        value: "${element.sId}",
        child: new Text("${element.name}"),
      ));
    });
    setState();
  }
}
