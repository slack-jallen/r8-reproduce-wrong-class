package com.example.setlisteners

import com.example.textextensions.addTextSpanWatcher

import android.widget.EditText
import com.example.textspanwatcher.BeginningFormatEnabledWatcher
import com.example.textspanwatcher.IndentSpanWatcher

interface SetListeners {

  fun setListeners()
}
class SetListenersImpl(val text: EditText): SetListeners {

  private val quoteAllTheThings = QuoteAllTheThings(true)

  override fun setListeners() {
    if (quoteAllTheThings.m1) {
      text.addTextSpanWatcher(IndentSpanWatcher())
      text.addTextSpanWatcher(BeginningFormatEnabledWatcher())
    }
  }
}