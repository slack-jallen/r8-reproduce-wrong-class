package com.example.textspanwatcher

import android.text.Spannable
import android.util.Log

class BeginningFormatEnabledWatcher: TextSpanWatcher() {
  override fun onChanged(spanned: Spannable) {
    Log.d("BeginningFormat", "onChanged $spanned")
  }
}