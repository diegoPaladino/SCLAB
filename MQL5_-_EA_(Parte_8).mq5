//+------------------------------------------------------------------+
//|                                          MQL5_-_EA_(Parte_8).mq5 |
//|                                                    diegoPaladino |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

//MQL5 - EA (Parte 8) - Verificação de Erros e Exceções - Expert Advisor
//https://www.youtube.com/watch?v=T7qgQEMTwEw


#property copyright "diegoPaladino"
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <Trade\Trade.mqh>
CTrade trade;

input int ma_periodo = 20;                                                 //Período da média
input int ma_desloc = 0;                                                   //Deslocamento da média
input ENUM_MA_METHOD ma_metodo = MODE_SMA;                                 //Método Média Móvel
input ENUM_APPLIED_PRICE ma_preco = PRICE_CLOSE;                           //Preço para Média
input ulong magicNumber = 123456;                                          //Magic Number
input ulong desvPts = 50;                                                  //Desvio em pontos
input double lote = 1;                                                     //Volume
input double stopLoss = 200;                                               //Stop Loss
input double takeProfit = 200;                                             //Take Profit
input ENUM_ORDER_TYPE_FILLING preenchimento = ORDER_FILLING_RETURN;        //Preenchimento da Ordem

double ask, bid, last;
double smaArray[];
int smaHandle;


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {

   smaHandle = iMA(_Symbol, _Period, ma_periodo, 0, ma_metodo, ma_preco);
   if(smaHandle==INVALID_HANDLE)
     {
         Print("Erro ao criar média móvel - erro", GetLastError());
         return(INIT_FAILED);
     }
   ArraySetAsSeries(smaArray, true);
   
   trade.SetTypeFilling(preenchimento);
   trade.SetDeviationInPoints(desvPts);
   trade.SetExpertMagicNumber(magicNumber);
   
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {

   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {

   
   ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   last = SymbolInfoDouble(_Symbol, SYMBOL_LAST);
   
   
   if(CopyBuffer(smaHandle, 0, 0, 3, smaArray)<0)
     {
         Alert("Erro ao copiar dados da média móvel: ", GetLastError());
         return;
     }
   
   if(last>smaArray[0] && PositionsTotal()==0)
     {
         if(trade.Buy(lote, _Symbol, ask, ask-stopLoss, ask+takeProfit, ""))
           {
               Print("Ordem de Compra - sem falha. ResultRetcode: ", trade.ResultRetcode(), "RetcodeDescription: ", trade.ResultRetcodeDescription());
           }
         else
           {
               Print("Ordem de Compra - com falha. ResultRetcode: ", trade.ResultRetcode(), "RetcodeDescription: ", trade.ResultRetcodeDescription());
           }
     }
   else if(last<smaArray[0] && PositionsTotal()==0)
     {
         if(trade.Sell(lote, _Symbol, bid, bid-stopLoss, bid+takeProfit, ""))
           {
               Print("Ordem de Compra - sem falha. ResultRetcode: ", trade.ResultRetcode(), "RetcodeDescription: ", trade.ResultRetcodeDescription());
           }
         else
           {
               Print("Ordem de Compra - com falha. ResultRetcode: ", trade.ResultRetcode(), "RetcodeDescription: ", trade.ResultRetcodeDescription());
           }
     }
  }