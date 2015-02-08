//+------------------------------------------------------------------+
//|                          4h_MACD_FX_Strategy_fixed_timeframe.mq4 |
//|                                     Giorgio "Obi Wan" Scarabello |
//|                            http://www.fxtradeblog.com/index.html |
//+------------------------------------------------------------------+
#property copyright "Giorgio Obi Wan Scarabello"
#property link      "http://www.fxtradeblog.com/index.html"

#property indicator_chart_window
#property indicator_buffers 5
#property indicator_color1 White //SkyBlue
#property indicator_color2 DarkOrange //MediumSeaGreen
#property indicator_color3 Red
#property indicator_color4 Blue
#property indicator_color5 Green

#property indicator_width1 1
#property indicator_width2 1
#property indicator_width3 1
#property indicator_width4 1
#property indicator_width5 1

#property indicator_style1 2
#property indicator_style2 2
#property indicator_style3 2
#property indicator_style4 2
#property indicator_style5 2
//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
double ExtMapBuffer4[];
double ExtMapBuffer5[];


//---- Variables
double EMA8, EMA8m;
double EMA21, EMA21m;
double SMA89, SMA89m;
double SMA200, SMA200m;
double EMA365, EMA365m;


int x=0, mx, my, y, z;
int limit;

int rhythm=0;
string rh="";
color rh_color;
string rh_arrows;

extern bool enable_text = true;
extern bool enable_moving_averages = true;
extern bool extended = true;
extern int fontsize = 8;
extern int corner = 0;
extern int xdispl = 1;
extern int ydispl = 1;
extern color strong_bullish_color = Lime;
extern color weak_bullish_color = PaleGreen;
extern color weak_bearish_color = HotPink;
extern color strong_bearish_color = Red;
extern color no_rhythm_color = White;
extern color roundover_color = SteelBlue;
extern color roundunder_color = Crimson;


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexLabel(0,"H4 EMA 8");
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,ExtMapBuffer2);
   SetIndexLabel(1,"H4 EMA 21");
   SetIndexStyle(2,DRAW_LINE);
   SetIndexBuffer(2,ExtMapBuffer3);
   SetIndexLabel(2,"H4 SMA 89");
   SetIndexStyle(3,DRAW_LINE);
   SetIndexBuffer(3,ExtMapBuffer4);
   SetIndexLabel(3,"H4 SMA 200");
   SetIndexStyle(4,DRAW_LINE);
   SetIndexBuffer(4,ExtMapBuffer5);
   SetIndexLabel(4,"H4 EMA 365");
//----
//----

   if (corner>3) corner=3;
   if (corner==0) xdispl=350;
   if (xdispl<1) xdispl=1;
   if (ydispl<1) xdispl=1;

//---- Text Object
   ObjectCreate("H4_Rhythm", OBJ_LABEL, 0, 0, 0);
   ObjectSet("H4_Rhythm", OBJPROP_CORNER, corner);
   ObjectSet("H4_Rhythm", OBJPROP_XDISTANCE, xdispl);
   ObjectSet("H4_Rhythm", OBJPROP_YDISTANCE, ydispl);  

   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int    counted_bars=IndicatorCounted();
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;

//Moving averages stuff
if(Period()<240)  
{
   mx=iBarShift(NULL,PERIOD_H4,iTime(NULL,0,limit),false);//iBars(NULL,PERIOD_H4);
   my=limit;
   for (x=iBarShift(NULL,PERIOD_H4,iTime(NULL,0,limit),false); x>=0; x--)
      {
         //calculation
         EMA8=iMA(NULL,PERIOD_H4,8,0,MODE_EMA,PRICE_CLOSE,x);
         EMA21=iMA(NULL,PERIOD_H4,21,0,MODE_EMA,PRICE_CLOSE,x);
         SMA89=iMA(NULL,PERIOD_H4,89,0,MODE_SMA,PRICE_CLOSE,x);
         SMA200=iMA(NULL,PERIOD_H4,200,0,MODE_SMA,PRICE_CLOSE,x);
         EMA365=iMA(NULL,PERIOD_H4,365,0,MODE_EMA,PRICE_CLOSE,x);
      
         y=iBarShift(NULL,0,iTime(NULL,PERIOD_H4,x),true);
         if(y!=-1)
            {
               for(z=my; z>y; z--)
                  {
                     ExtMapBuffer1[z]=EMA8m;
                     ExtMapBuffer2[z]=EMA21m;
                     ExtMapBuffer3[z]=SMA89m;
                     ExtMapBuffer4[z]=SMA200m;
                     ExtMapBuffer5[z]=EMA365m;
                  }
               //drawing
               ExtMapBuffer1[y]=EMA8;
               ExtMapBuffer2[y]=EMA21;
               ExtMapBuffer3[y]=SMA89;
               ExtMapBuffer4[y]=SMA200;
               ExtMapBuffer5[y]=EMA365;
               
               EMA8m=EMA8;
               EMA21m=EMA21;
               SMA89m=SMA89;
               SMA200m=SMA200;
               EMA365m=EMA365;
               
               mx=x;
               my=y-1;
               
               
            }
      }
   int k;
   for(k=my; k>=0; k--)
      {
         ExtMapBuffer1[k]=EMA8m;
         ExtMapBuffer2[k]=EMA21m;
         ExtMapBuffer3[k]=SMA89m;
         ExtMapBuffer4[k]=SMA200m;
         ExtMapBuffer5[k]=EMA365m;
      }
      
   //Rhythm stuff
   if (enable_text==true)
   {
     //calculation
         EMA8=iMA(NULL,PERIOD_H4,8,0,MODE_EMA,PRICE_CLOSE,0);
         //EMA21=iMA(NULL,PERIOD_H4,21,0,MODE_EMA,PRICE_CLOSE,x);
         SMA89=iMA(NULL,PERIOD_H4,89,0,MODE_SMA,PRICE_CLOSE,0);
         //SMA200=iMA(NULL,PERIOD_H4,200,0,MODE_SMA,PRICE_CLOSE,x);
         //EMA365=iMA(NULL,PERIOD_H4,365,0,MODE_EMA,PRICE_CLOSE,x);
     
     
     
     
     
      rhythm=0;
      if (Close[0]>SMA89)
         {
            rhythm=1;
            rh="Weak Bullish";
            rh_color=weak_bullish_color;
            rh_arrows=CharToStr(143)+CharToStr(225);
      
            if (Close[0]>EMA8)
            {
               rhythm++;
               rh="Strong Bullish";
               rh_color=strong_bullish_color;
               rh_arrows=CharToStr(143)+CharToStr(225)+CharToStr(225);
            }
          }
       else if (Close[0]<SMA89)
         {
            rhythm=-1;
            rh="Weak Bearish";
            rh_color=weak_bearish_color;
            rh_arrows=CharToStr(143)+CharToStr(226);
      
            if (Close[0]<EMA8)
               {
                  rhythm--;
                  rh="Strong Bearish";
                  rh_color=strong_bearish_color;
                  rh_arrows=CharToStr(143)+CharToStr(226)+CharToStr(226);
               }
         }
       else
         {
            rhythm=0;
            rh="No Rhythm";
            rh_color=no_rhythm_color;
            rh_arrows=CharToStr(200)+CharToStr(223)+CharToStr(224);
         }
   
 
       if (extended==false)
         {
            ObjectSetText("H4_Rhythm", rh_arrows,fontsize+4,"Wingdings",rh_color);
         }
       else
         {
            ObjectSetText("H4_Rhythm", "H4 Rhythm="+rh,fontsize,"Tahoma",rh_color);
         }
   }
   else
   {
      xdispl=0;
      ydispl=0;
      ObjectSet("H4_Rhythm", OBJPROP_XDISTANCE, xdispl);
      ObjectSet("H4_Rhythm", OBJPROP_YDISTANCE, ydispl);  
   }
}


//----
   return(0);
  }
//+------------------------------------------------------------------+