package com.example.myapplication

import android.text.Editable
import android.text.SpanWatcher
import android.text.Spannable
import android.text.TextWatcher

abstract class TextSpanWatcher: TextWatcher, SpanWatcher {

  override fun beforeTextChanged(s: CharSequence?, start: Int, count: Int, after: Int) {
  }

  override fun onTextChanged(s: CharSequence?, start: Int, before: Int, count: Int) {
  }

  override fun onSpanAdded(text: Spannable?, what: Any?, start: Int, end: Int) {
  }

  override fun onSpanRemoved(text: Spannable?, what: Any?, start: Int, end: Int) {
  }

  override fun onSpanChanged(
    text: Spannable?,
    what: Any?,
    ostart: Int,
    oend: Int,
    nstart: Int,
    nend: Int
  ) {
  }

  override fun afterTextChanged(s: Editable) {
    onChanged(s)
  }

  protected abstract fun onChanged(spanned: Spannable)
}