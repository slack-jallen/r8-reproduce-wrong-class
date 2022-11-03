package com.example.textspanwatcher

import android.text.Spannable
import android.util.Log

class BeginningFormatEnabledWatcher: TextSpanWatcher() {
  init {
    // Creating BeginningFormatEnabledWatcher com.example.textspanwatcher.IndentSpanWatcher@2e602c6
    check(!this.toString().contains("IndentSpanWatcher")) { this.toString() }
  }
  override fun onChanged(spanned: Spannable) {
    Log.d("BeginningFormat", "onChanged $spanned")
  }
}