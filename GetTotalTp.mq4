//+------------------------------------------------------------------+
//|                                                   GetTotalTp.mq4 |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql4.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql4.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+

#property show_inputs

extern bool g_debug = true;
extern double g_initStop = 27;
extern double g_breakEven = 20;
extern double g_stepSize = 3;
extern double g_measure = 10;
extern double g_stopMax = 200;
extern double g_profitExtendThreshold = 0.75;
extern double g_profitMax = 0; // close order if profit reaches the pre-defined max value


double pt = 0;

int init() {

    if(Digits==3 || Digits==5) 
    {
      pt=10*Point;
    }
   else                          
      pt=Point;
    doStepStop();
    return(0);
}

/*
1. 检测所下单子，若单子未设置止损和止盈，则根据默认输入参数设置止损和止盈。
2. 若单子发生盈利，并达到移动止损触发线，则动态提高原有止损线，进入追踪止损状态。
3. 若单子一直盈利，止损的范围也会随着盈利的比例变大而变大。
4. 若单子盈利已经达到预期止盈目标的 75%，则动态提高止盈线，给出更多上涨空间。
总而言之，即是上涨时尽量扩大盈利目标，跌落时尽量保住既有盈利。
*/


int doStepStop() {
    int total = OrdersTotal();
    for (int i = 0; i < total; i++) {
        if (OrderSelect(i, SELECT_BY_POS)) {
            if (OrderSymbol() != Symbol()) {
                continue;
            }
            double flag = 0;
            double price = 0; // current price
            double desiredProfit = 0;
            double realProfit = 0;
            double profitModifier = 0;
            double takeProfit = OrderTakeProfit(); /* 得到订单的止盈 */
            double stopLoss = OrderStopLoss();     /* 得到订单的止损 */
            double stepStopTrigger = (g_breakEven + g_initStop) * pt;
            

            
            if (OrderType() == OP_BUY) {
               flag = 1;
               price = Bid;
            }    
            else if (OrderType() == OP_SELL) {
               flag = -1;
               price = Ask;
            } else {
               continue;
            }
            if (takeProfit <= 0) {/* 没有设置止盈 */
                takeProfit = OrderOpenPrice() + flag * (g_breakEven + g_initStop + g_stepSize) * pt; /* 止盈价 */
            }
            if (stopLoss <= 0) { /* 没有设置止损 */
                stopLoss = OrderOpenPrice() - flag * g_initStop * pt; /* 止损价 */
            }
            
            /* 目标盈利 */
            desiredProfit = MathAbs(takeProfit - OrderOpenPrice()); /* 止盈价和开盘价的点值 */

            if (desiredProfit <= pt) {
                continue;
            }
            
            /* 当前盈利 */
            realProfit = flag * (price - OrderOpenPrice()); // could be a negtive number!
            
        
            if (realProfit > 0) {/* 当前盈利大于 0 */
            
                /* 当前盈利达到止盈的%75 或者  当前盈利和止盈相差很小时，这时候扩大止盈*/
                if ((realProfit / desiredProfit > g_profitExtendThreshold) || (desiredProfit - realProfit < 2 * g_stepSize * pt)) {
                    // profitModifier is always a positive number
                    profitModifier = MathMax(desiredProfit / g_profitExtendThreshold + g_stepSize * pt, desiredProfit + 2 * g_stepSize * pt);
                }
                if (desiredProfit - stepStopTrigger > 0) {
                    if ((desiredProfit - realProfit > 0) && (realProfit - stepStopTrigger > 0)) {
                        double k = (desiredProfit - realProfit) / (g_measure * pt);
                        stopLoss = price - flag * (k * g_stepSize + g_initStop) * pt;
                        
                        /* 盈利超过止损触发线后,上移止损*/
                        if (flag * (stopLoss - OrderStopLoss()) < 0 || MathAbs(stopLoss - OrderStopLoss()) < g_stepSize * pt) {
                            stopLoss = OrderStopLoss();  /* 如果新的止损 扩大了止损点位，这时候止损不变 */
                        }
                    }
                }
            }
            stopLoss = NormalizeDouble(stopLoss, Digits);
            if (MathAbs(takeProfit - OrderOpenPrice()) < profitModifier) {
                if (g_profitMax > 0 && profitModifier - g_profitMax * pt > 0) {
                    profitModifier = g_profitMax * pt;
                }
                takeProfit = OrderOpenPrice() + flag * profitModifier;
            }
            takeProfit = NormalizeDouble(takeProfit, Digits);
            if (MathAbs(stopLoss - OrderStopLoss()) >= pt || MathAbs(takeProfit - OrderTakeProfit()) >= pt) {
                Print("order before modify: tk(" + OrderTicket() + "), sl(" + DoubleToStr(OrderStopLoss(), 4) + "), tp(" + DoubleToStr(OrderTakeProfit(), 4) + ")"); 
                OrderModify(OrderTicket(), OrderOpenPrice(), stopLoss, takeProfit, 0);            
            }
        }
    }
    return(0);
}


int start()
{
//---
   
   doStepStop();
   return 0;
}
//+------------------------------------------------------------------+
