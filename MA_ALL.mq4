//+------------------------------------------------------------------+
//|                                                       MA_ALL.mq4 |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql4.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql4.com"
#property version   "1.00"
#property strict

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

//#property indicator_style1 2
//#property indicator_style2 2
//#property indicator_style3 2
//#property indicator_style4 2
//#property indicator_style5 2

double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
double ExtMapBuffer4[];
double ExtMapBuffer5[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//--- indicator buffers mapping
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
//---
   return(INIT_SUCCEEDED);
  }
  
int deinit()
{
   return(0);
}
  
void sma(int period,int counted_bars,double & buffer[])
{

   double sum=0;
   int    i,pos=Bars-counted_bars-1;
   //---- initial accumulation
   SetIndexDrawBegin(0,period-1);
   if(pos<period) pos=period;
   for(i=1;i<period;i++,pos--)
      sum+=Close[pos];
   //---- main calculation loop
   while(pos>=0)
     {
      sum+=Close[pos];
      buffer[pos]=sum/period;
	   sum-=Close[pos+period-1];
 	   pos--;
     }
   //---- zero initial bars
   if(counted_bars<1)
      for(i=1;i<period;i++) buffer[Bars-i]=0;
}
  
  
void ema(int period,int counted_bars,double & buffer[])
{
   double pr=2.0/(period+1);
   int    pos=Bars-2;
   SetIndexDrawBegin(0,period-1);
   if(counted_bars>2) pos=Bars-counted_bars-1;
   while(pos>=0)
   {
      if(pos==Bars-2) buffer[pos+1]=Close[pos+1];
      buffer[pos]=Close[pos]*pr+buffer[pos+1]*(1-pr);
 	   pos--;
   }
}
  
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
{
//---
   int    counted_bars=IndicatorCounted();
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   
   ema(8,counted_bars,ExtMapBuffer1);
   ema(21,counted_bars,ExtMapBuffer2);
   sma(89,counted_bars,ExtMapBuffer3);
   sma(200,counted_bars,ExtMapBuffer4);
   ema(365,counted_bars,ExtMapBuffer5);
   


   return(0);
}
//+------------------------------------------------------------------+
