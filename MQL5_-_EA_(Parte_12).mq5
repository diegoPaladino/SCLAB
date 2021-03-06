//+------------------------------------------------------------------+
//|                                         MQL5_-_EA_(Parte_12).mq5 |
//|                                                    diegoPaladino |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

//MQL5 - EA (Parte 12) - Verificação de Ordem Pendente - Expert Advisor
//https://www.youtube.com/watch?v=0GDWguihG00

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
input ENUM_ORDER_TYPE_FILLING preenchimento = ORDER_FILLING_RETURN;        //Preenchimento da Ordem

input double lote = 1;                                                     //Volume
input double stopLoss = 200;                                               //Stop Loss
input double takeProfit = 200;                                             //Take Profit

double smaArray[];
int smaHandle;

bool posAberta;
bool ordPendente;

MqlTick ultimoTick;
MqlRates rates[];


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {

   smaHandle = iMA(_Symbol, _Period, ma_periodo, ma_desloc, ma_metodo, ma_preco);
   if(smaHandle==INVALID_HANDLE)
     {
         Print("Erro ao criar média móvel - erro", GetLastError());
         return(INIT_FAILED);
     }
   ArraySetAsSeries(smaArray, true);
   ArraySetAsSeries(rates, true);
   
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

   if(!SymbolInfoTick(_Symbol,ultimoTick))
     {
         Alert("Erro ao obter informações de preços: ", GetLastError());
         return;
     }
     
   if(CopyRates(_Symbol, _Period, 0, 3, rates)<0)
     {
         Alert("Erro ao obter as informações de MqlRates: ", GetLastError());
         return;
     }
     
     posAberta = false;
     for(int i=PositionsTotal()-1; i>=0; i--)
       {
         string symbol = PositionGetSymbol(i);
         ulong magic = PositionGetInteger(POSITION_MAGIC);
         if(symbol == _Symbol && magic == magicNumber)
           {
               posAberta = true;
               break;
           }
       }
       
     ordPendente = false;
     
   
   if(CopyBuffer(smaHandle, 0, 0, 3, smaArray)<0)
     {
         Alert("Erro ao copiar dados da média móvel: ", GetLastError());
         return;
     }
   
   if(ultimoTick.last>smaArray[0] && rates[1].close>rates[1].open && !posAberta)
     {
         if(trade.Buy(lote, _Symbol, ultimoTick.ask, ultimoTick.ask-stopLoss, ultimoTick.ask+takeProfit, ""))
           {
               Print("Ordem de Compra - sem falha. ResultRetcode: ", trade.ResultRetcode(), " RetcodeDescription: ", trade.ResultRetcodeDescription());
           }
         else
           {
               Print("Ordem de Compra - com falha. ResultRetcode: ", trade.ResultRetcode(), " RetcodeDescription: ", trade.ResultRetcodeDescription());
           }
     }
   else if(ultimoTick.last<smaArray[0] && rates[1].close<rates[1].open && !posAberta)
     {
         if(trade.Sell(lote, _Symbol, ultimoTick.bid, ultimoTick.bid+stopLoss, ultimoTick.bid-takeProfit, ""))
           {
               Print("Ordem de Compra - sem falha. ResultRetcode: ", trade.ResultRetcode(), " RetcodeDescription: ", trade.ResultRetcodeDescription());
           }
         else
           {
               Print("Ordem de Compra - com falha. ResultRetcode: ", trade.ResultRetcode(), " RetcodeDescription: ", trade.ResultRetcodeDescription());
           }
     }
  }