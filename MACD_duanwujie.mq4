#property copyright "GOLDEN "
//#property link      "zx815@126.com "
#property link      "dhacklove@163.com "

#property indicator_separate_window
#property indicator_buffers 4
#property indicator_color1 DarkGray
#property indicator_color2 Blue
#property indicator_color3 Red

#property indicator_color4 Lime

extern int FastEMA = 5;
extern int SlowEMA = 13;
extern int SignalSMA = 1;
double ColumnBuffer0[];
double ColumnBuffer1[];
double ColumnBuffer2[];
double DeaBuffer[];
double DiffBuffer[];


extern double Level1 = 0.0045;
extern double Level2 = 0.0030;
extern double Level3 = 0.0015;
extern double Level4 = -0.0015;
extern double Level5 = -0.0030;
extern double Level6 = -0.0045;


int init() {
   IndicatorBuffers(5);
   SetIndexStyle(0, DRAW_HISTOGRAM);
   SetIndexStyle(1, DRAW_HISTOGRAM);
   SetIndexStyle(2, DRAW_HISTOGRAM);
   SetIndexStyle(3, DRAW_LINE);
   SetIndexStyle(4, DRAW_NONE);
   
   
   
   IndicatorDigits(Digits + 1);
   SetIndexBuffer(0, ColumnBuffer0);
   SetIndexBuffer(1, ColumnBuffer1);
   SetIndexBuffer(2, ColumnBuffer2);
   SetIndexBuffer(3, DeaBuffer);
   SetIndexBuffer(4, DiffBuffer);
   

   //IndicatorShortName("Golden MACD(" + FastEMA + "," + SlowEMA + "," + SignalSMA + ")");
   IndicatorShortName("Golden MACD");

   SetIndexLabel(0, "MACD");
   SetIndexLabel(1, "MACD");
   SetIndexLabel(2, "MACD");
   SetIndexLabel(3, "Signal");
   
   ObjectCreate("Line1",OBJ_HLINE,WindowsTotal()-1,0,Level3);
   ObjectCreate("Line2",OBJ_HLINE,WindowsTotal()-1,0,Level2);
   ObjectCreate("Line3",OBJ_HLINE,WindowsTotal()-1,0,Level1);
   ObjectCreate("Line4",OBJ_HLINE,WindowsTotal()-1,0,Level4);
   ObjectCreate("Line5",OBJ_HLINE,WindowsTotal()-1,0,Level5);
   ObjectCreate("Line6",OBJ_HLINE,WindowsTotal()-1,0,Level6);
   
   ObjectSet("Line1",OBJPROP_COLOR,Green);
   ObjectSet("Line2",OBJPROP_COLOR,Green);
   ObjectSet("Line3",OBJPROP_COLOR,Green);
   ObjectSet("Line4",OBJPROP_COLOR,Green);
   ObjectSet("Line5",OBJPROP_COLOR,Green);
   ObjectSet("Line6",OBJPROP_COLOR,Green);
   return (0);
}


int top[300];
int guaidian[300];
int bottom[300];

int start() {

   long current_chart_id=ChartID();//当前图标ID
   
   
   int counted_bars = IndicatorCounted();
   if (counted_bars > 0) counted_bars--;
   int limit = Bars - counted_bars;
   for (int i = 0; i < limit; i++){ 
		DiffBuffer[i] = iMA(NULL, 0, FastEMA, 0, MODE_EMA, PRICE_CLOSE, i) - iMA(NULL, 0, SlowEMA, 0, MODE_EMA, PRICE_CLOSE, i);
	}
   for (i = 0; i < limit; i++) 
		DeaBuffer[i] = iMAOnArray(DiffBuffer, Bars, SignalSMA, 0, MODE_SMA, i);
	
   

  
  
/*

   int k = 0;
   int g = 0;
	for(i=0;i<300;i++){
   
      if(DeaBuffer[i]<0 || DeaBuffer[i+1]<0 || DeaBuffer[i+2]<0)
         continue;

      //求定点
	   if((DeaBuffer[i+1]>DeaBuffer[i]) && (DeaBuffer[i+1]>DeaBuffer[i+2]))
	   {
	      top[k]=i+1;
	      k++;
	   }else if((DeaBuffer[i+1]<DeaBuffer[i]) && (DeaBuffer[i+1]<DeaBuffer[i+2]))
	   {
	      top[k]=i+1;
	      k++;
	   }
	}
   string up_a;
   for(i=0;i<k;i++)
   {
      double rate = (DeaBuffer[top[i+1]]-DeaBuffer[top[i]])/(top[i+1]-top[i]);
      //printf("rate: %f",rate);
      //ObjectCreate(“ellipse”, OBJ_ELLIPSE, 0, x1, y1, x2, y2) 

      if(rate >= 0)
      {
         up_a = top[i+1];
         ObjectCreate("UP"+up_a,OBJ_ARROW,0,Time[top[i+1]],Open[top[i+1]]);
         ObjectSet("UP"+up_a, OBJPROP_STYLE, STYLE_DOT);
         ObjectSet("UP"+up_a,OBJPROP_ARROWCODE,SYMBOL_ARROWUP);
         ObjectSet("UP"+up_a,OBJPROP_COLOR,Yellow);
         ObjectSet("UP"+up_a,OBJPROP_WIDTH,2);
         
         
         //ObjectCreate(current_chart_id,"Trend"+up_a,OBJ_TREND,WindowsTotal()-1,top[i+1],DeaBuffer[top[i+1]],top[i+1],DeaBuffer[top[i+1]]);
         
         //ObjectCreate(current_chart_id,"Ellipse"+up_a,OBJ_ELLIPSE,0,Time[top[i+1]],Open[top[i+1]]);
         //ObjectSetDouble(current_chart_id,"Ellipse"+up_a,OBJPROP_SCALE,0.02);

         
      }
  
   }
   
 */

   
   //ObjectCreate("ellipse",OBJ_ARROW,0,Time[1],Bid,Time[1],Bid);
	
  
	

	
	
   for (i = 0; i < limit; i++) {
      if (DiffBuffer[i] > 0.0 && DiffBuffer[i] >= DeaBuffer[i]) {
         ColumnBuffer1[i] = DiffBuffer[i];
         ColumnBuffer2[i] = 0;
         ColumnBuffer0[i] = 0;
      }
      if (DiffBuffer[i] < 0.0 && DiffBuffer[i] <= DeaBuffer[i]) {
         ColumnBuffer2[i] = DiffBuffer[i];
         ColumnBuffer1[i] = 0;
         ColumnBuffer0[i] = 0;
      }
      if ((DiffBuffer[i] > 0.0 && DiffBuffer[i] < DeaBuffer[i]) || (DiffBuffer[i] < 0.0 && DiffBuffer[i] > DeaBuffer[i])) {
         ColumnBuffer0[i] = DiffBuffer[i];
         ColumnBuffer1[i] = 0;
         ColumnBuffer2[i] = 0;
      }
   }
   return (0);
}
