class ActionOnConditionController
{
   bool _finished;
   ICondition *_condition;
   IAction* _action;
public:
   ActionOnConditionController()
   {
      _action = NULL;
      _condition = NULL;
      _finished = true;
   }

   ~ActionOnConditionController()
   {
      delete _action;
      delete _condition;
   }
   
   bool SetOrder(IAction* action, ICondition *condition)
   {
      if (!_finished || action == NULL)
         return false;

      if (_action != NULL)
         _action.Release();
      _action = action;
      _action.AddRef();
      _finished = false;
      delete _condition;
      _condition = condition;
      return true;
   }

   void DoLogic(const int period)
   {
      if (_finished)
         return;

      if ( _condition.IsPass(period))
      {
         if (_action.DoAction())
            _finished = true;
      }
   }
};