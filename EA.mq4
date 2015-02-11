extern string G_Parameters = "---- Trade Management ----";
extern int MaxTrades = 1;
extern double TakeProfit = 30;//30/40//50
extern int StopLoss = 75;
extern bool UseHourTrade = FALSE;
extern int FromHourTrade = 6;
extern int ToHourTrade = 18;
extern int magic = 3557;
extern string MM_Parameters = "---- Money Management ----";
extern double Lots = 1.0;
extern bool MM = FALSE;
extern bool AccountIsMicro = FALSE;
extern int Risk = 15;
double gd_144 = 1.0;
int g_error_152;


double setpoint() {
double ld_ret_0;
if (Digits <= 3) ld_ret_0 = 0.01;
else ld_ret_0 = 0.0001;
return (ld_ret_0);
}

int init() {
string ls_0 = "2019.08.08";
int l_str2time_8 = StrToTime(ls_0);
if (TimeCurrent() >= l_str2time_8) {
  Print("The trial version has been expired");
  return (0);
}
if (Period() != PERIOD_M15) {
  Print("Please select 15 min period.");
  return (0);
}
SetDigits();
HideTestIndicators(TRUE);
return (0);
}

void SetDigits() {
if (Digits == 5 || Digits == 3) gd_144 = 10;
}

void deinit() {
Comment("");
}

int orderscnt() {
int l_count_0 = 0;
for (int l_pos_4 = 0; l_pos_4 < OrdersTotal(); l_pos_4++) {
  if (OrderSelect(l_pos_4, SELECT_BY_POS, MODE_TRADES))
     if (OrderSymbol() == Symbol() && magic == OrderMagicNumber()) l_count_0++;
}
return (l_count_0);
}

int start() {
double ld_0;
double ld_8;
int l_ticket_16;
//ads();
double l_ihigh_20 = iHigh(NULL, 0, 1);
double l_ihigh_28 = iHigh(NULL, 0, 2);
double l_ihigh_36 = iHigh(NULL, 0, 1);
double l_ihigh_44 = iHigh(NULL, 0, 2);
double l_ilow_52 = iLow(NULL, 0, 1);
double l_ilow_60 = iLow(NULL, 0, 2);
double l_ilow_68 = iLow(NULL, 0, 1);
double l_ilow_76 = iLow(NULL, 0, 2);
double l_ima_84 = iMA(NULL, 0, 3, 0, MODE_EMA, PRICE_CLOSE, 1);
double l_ima_92 = iMA(NULL, 0, 13, 0, MODE_EMA, PRICE_CLOSE, 1);
double l_ima_100 = iMA(NULL, 0, 36, 0, MODE_EMA, PRICE_CLOSE, 1);
double l_imomentum_108 = iMomentum(NULL, 0, 100, PRICE_OPEN, 0);
double l_iadx_116 = iADX(NULL, 0, 41, PRICE_CLOSE, MODE_MAIN, 0);
double l_irsi_124 = iRSI(NULL, 0, 31, PRICE_CLOSE, 0);
// Comments();
if (MM) Lots = subLotSize();
int l_ord_total_132 = OrdersTotal();
if (l_ord_total_132 < 1) {
  if (l_ihigh_20 < l_ima_100 || l_ima_84 > l_ima_92 || (l_ilow_52 > l_ilow_60 && l_ilow_76 > l_ilow_60 && l_ihigh_36 > l_ihigh_28) && l_imomentum_108 > 100.0 && l_iadx_116 > 19.0 &&
     l_irsi_124 > 70.0) {
     if (orderscnt() < MaxTrades) {
        if (StopLoss == 0) ld_0 = 0;
        else ld_0 = Ask - StopLoss * setpoint() * gd_144;
        if (TakeProfit == 0.0) ld_8 = 0;
        else ld_8 = Ask + TakeProfit * setpoint() * gd_144;
        l_ticket_16 = OrderSend(Symbol(), OP_BUY, Lots, NormalizeDouble(Ask, Digits), 2, 0, 0, "Ripper", magic, 0, Blue);
        if (l_ticket_16 <= 0) {
           g_error_152 = GetLastError();
           if (g_error_152 > 0) Print("BuyOrderSend failed: ", g_error_152, ": ", g_error_152);
        } else OrderModify(l_ticket_16, OrderOpenPrice(), NormalizeDouble(ld_0, Digits), NormalizeDouble(ld_8, Digits), 0, CLR_NONE);
        PlaySound("Alert.wav");
     }
  }
  if (l_ilow_52 > l_ima_100 || l_ima_92 > l_ima_84 || (l_ihigh_28 > l_ihigh_20 && l_ihigh_28 > l_ihigh_44 && l_ilow_60 > l_ilow_68) && l_imomentum_108 < 100.0 && l_iadx_116 < 21.0 &&
     l_irsi_124 < 30.0) {
     if (orderscnt() < MaxTrades) {
        if (StopLoss == 0) ld_0 = 0;
        else ld_0 = Bid + StopLoss * setpoint() * gd_144;
        if (TakeProfit == 0.0) ld_8 = 0;
        else ld_8 = Bid - TakeProfit * setpoint() * gd_144;
        l_ticket_16 = OrderSend(Symbol(), OP_SELL, Lots, NormalizeDouble(Bid, Digits), 2, 0, 0, "Ripper", magic, 0, Red);
        if (l_ticket_16 <= 0) {
           g_error_152 = GetLastError();
           if (g_error_152 > 0) Print("SellOrderSend failed: ", g_error_152, ": ", g_error_152);
        } else OrderModify(l_ticket_16, OrderOpenPrice(), NormalizeDouble(ld_0, Digits), NormalizeDouble(ld_8, Digits), 0, CLR_NONE);
        PlaySound("Alert.wav");
     }
  }
  return (0);
}
return (0);
}

void Comments() {
string ls_0 = "";
string ls_8 = "\n";
string ls_16 = ""
  + "\n"
  + " Copyright ?2010, ForexRipperEA"
  + "\n"
  + "======================"
  + "\n"
  + "BROKER INFORMATION:"
  + "\n"
  + "Broker:        " + AccountCompany()
  + "\n"
  + "======================"
  + "\n"
  + "MARGIN INFORMATION:"
  + "\n"
  + "Free Margin:            " + DoubleToStr(AccountFreeMargin(), 2) + ls_8 + "Used Margin:            " + DoubleToStr(AccountMargin(), 2)
  + "\n"
+ "======================" + ls_8;
for (int l_count_24 = 0; !IsStopped() && !IsConnected(); l_count_24++) {
  ls_0 = "Not connected.";
  Sleep(150);
}
if (UseHourTrade)
  if (!(Hour() >= FromHourTrade && Hour() <= ToHourTrade)) ls_0 = "Non-Trading Hours!";
Comment(ls_16 + ls_0);
}

double subLotSize() {
double ld_ret_0 = MathCeil(AccountFreeMargin() * Risk / 1000.0) / 100.0;
if (AccountIsMicro == FALSE) {
  if (ld_ret_0 < 0.1) ld_ret_0 = Lots;
  if (ld_ret_0 > 0.5 && ld_ret_0 < 1.0) ld_ret_0 = 0.5;
  if (ld_ret_0 > 1.0) ld_ret_0 = MathCeil(ld_ret_0);
  if (ld_ret_0 > 100.0) ld_ret_0 = 100;
} else {
  if (ld_ret_0 < 0.01) ld_ret_0 = Lots;
  if (ld_ret_0 > 1.0) ld_ret_0 = MathCeil(ld_ret_0);
  if (ld_ret_0 > 100.0) ld_ret_0 = 100;
}
return (ld_ret_0);
}