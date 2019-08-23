// Trend value cell v1.0

#ifndef TrendValueCell_IMP
#define TrendValueCell_IMP

#include <../conditions/ICondition.mq4>
#include <../Signaler.mq4>

class TrendValueCell : public ICell
{
   string _id; int _x; int _y; string _symbol; ENUM_TIMEFRAMES _timeframe; datetime _lastDatetime;
   ICondition* _upCondition;
   ICondition* _downCondition;
   Signaler* _signaler;
   datetime _lastSignalDate;
public:
   TrendValueCell(const string id, const int x, const int y, const string symbol, const ENUM_TIMEFRAMES timeframe, Signaler* signaler)
   { 
      _signaler = signaler;
      _id = id; 
      _x = x; 
      _y = y; 
      _symbol = symbol; 
      _timeframe = timeframe; 
      _upCondition = new UpCondition(_symbol, _timeframe);
      _downCondition = new DownCondition(_symbol, _timeframe);
   }

   ~TrendValueCell()
   {
      delete _upCondition;
      delete _downCondition;
   }

   virtual void Draw()
   { 
      int direction = GetDirection(); 
      ObjectMakeLabel(_id, _x, _y, GetDirectionSymbol(direction), GetDirectionColor(direction), 1, WindowNumber, "Arial", font_size); 
      if (Time[0] != _lastSignalDate)
      {
         switch (direction)
         {
            case ENTER_BUY_SIGNAL:
               _signaler.SendNotifications("Buy");
               _lastSignalDate = Time[0];
               break;
            case ENTER_SELL_SIGNAL:
               _signaler.SendNotifications("Sell");
               _lastSignalDate = Time[0];
               break;
         }
      }
   }

private:
   int GetDirection()
   {
      if (_upCondition.IsPass(0))
         return ENTER_BUY_SIGNAL;
      if (_downCondition.IsPass(0))
         return ENTER_SELL_SIGNAL;
      return 0;
   }

   color GetDirectionColor(const int direction) { if (direction >= 1) { return Up_Color; } else if (direction <= -1) { return Dn_Color; } return Neutral_Color; }
   string GetDirectionSymbol(const int direction)
   {
      if (direction == ENTER_BUY_SIGNAL)
         return "BUY";
      else if (direction == ENTER_SELL_SIGNAL)
         return "SELL";
      return "-";
   }
};
#endif