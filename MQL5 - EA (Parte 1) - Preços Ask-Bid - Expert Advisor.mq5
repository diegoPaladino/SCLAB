//+------------------------------------------------------------------+
//|        MQL5 - EA (Parte 1) - Preços Ask-Bid - Expert Advisor.mq5 |
//|                                                    diegoPaladino |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "diegoPaladino"
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   double ask,bid;
   ask=SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   bid=SymbolInfoDouble(_Symbol, SYMBOL_BID);
   
   Comment("Preço ASK= ",ask, "\nPreço BID= ",bid);
  }
//+------------------------------------------------------------------+
