dnl Copyright 2002, The libsigc++ Development Team 
dnl 
dnl This library is free software; you can redistribute it and/or 
dnl modify it under the terms of the GNU Lesser General Public 
dnl License as published by the Free Software Foundation; either 
dnl version 2.1 of the License, or (at your option) any later version. 
dnl 
dnl This library is distributed in the hope that it will be useful, 
dnl but WITHOUT ANY WARRANTY; without even the implied warranty of 
dnl MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU 
dnl Lesser General Public License for more details. 
dnl 
dnl You should have received a copy of the GNU Lesser General Public 
dnl License along with this library; if not, write to the Free Software 
dnl Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA 
dnl
divert(-1)

include(template.macros.m4)

define([RETYPE_RETURN_OPERATOR],[dnl
  template <LOOP(class T_arg%1, $1)>
  inline T_return operator()(LOOP(T_arg%1 _A_a%1, $1))
    { return T_return(functor_.LIBSIGC_TEMPLATE_PREFIX operator()<LOOP(_P_(T_arg%1), $1)>
        (LOOP(_A_a%1, $1)));
    }

])
define([RETYPE_RETURN_VOID_OPERATOR],[dnl
  template <LOOP(class T_arg%1, $1)>
  inline void operator()(LOOP(T_arg%1 _A_a%1, $1))
    { functor_.LIBSIGC_TEMPLATE_PREFIX operator()<LOOP(_P_(T_arg%1), $1)>
        (LOOP(_A_a%1, $1));
    }

])

divert(0)dnl
__FIREWALL__
#include <sigc++/adaptors/adaptor_trait.h>

namespace sigc {

template <class T_return, class T_functor>
struct retype_return_functor : public adapts<T_functor>
{
  template <LOOP(class T_arg%1=void, CALL_SIZE)>
  struct deduce_result_type
    { typedef T_return type; };
  typedef T_return result_type;

  T_return operator()();

FOR(1,CALL_SIZE,[[RETYPE_RETURN_OPERATOR(%1)]])dnl
  retype_return_functor() {}
  retype_return_functor(_R_(T_functor) _A_functor)
    : adapts<T_functor>(_A_functor)
    {}
};

template <class T_return, class T_functor>
T_return retype_return_functor<T_return, T_functor>::operator()()
  { return T_return(functor_()); }


// void specialization needed because of explicit cast to T_return
template <class T_functor>
struct retype_return_functor<void, T_functor> : public adapts<T_functor>
{
  template <LOOP(class T_arg%1=void, CALL_SIZE)>
  struct deduce_result_type
    { typedef void type; };
  typedef void result_type;

  void operator()();

FOR(1,CALL_SIZE,[[RETYPE_RETURN_VOID_OPERATOR(%1)]])dnl
  retype_return_functor() {}
  retype_return_functor(_R_(T_functor) _A_functor)
    : adapts<T_functor>(_A_functor)
    {}
};

template <class T_functor>
void retype_return_functor<void, T_functor>::operator()()
  { functor_(); }


template <class T_action, class T_return, class T_functor>
void visit_each(const T_action& _A_action,
                const retype_return_functor<T_return, T_functor>& _A_target)
{
  visit_each(_A_action, _A_target.functor_);
}


template <class T_return, class T_functor>
inline retype_return_functor<T_return, T_functor>
retype_return(const T_functor& _A_functor)
  { return retype_return_functor<T_return, T_functor>(_A_functor); }

template <class T_functor>
inline retype_return_functor<void, T_functor>
hide_return(const T_functor& _A_functor)
  { return retype_return_functor<void, T_functor>(_A_functor); }

} /* namespace sigc */
