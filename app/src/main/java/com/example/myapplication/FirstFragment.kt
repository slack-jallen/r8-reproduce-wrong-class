package com.example.myapplication

import android.os.Bundle
import android.util.Log
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.EditText
import android.widget.TextView
import androidx.navigation.fragment.findNavController
import com.example.myapplication.databinding.FragmentFirstBinding

/**
 * A simple [Fragment] subclass as the default destination in the navigation.
 */
class FirstFragment : Fragment() {

  private val quoteAllTheThings = QuoteAllTheThings(true)
  private var _binding: FragmentFirstBinding? = null

  // This property is only valid between onCreateView and
  // onDestroyView.
  private val binding get() = _binding!!

  override fun onCreateView(
    inflater: LayoutInflater, container: ViewGroup?,
    savedInstanceState: Bundle?
  ): View? {

    _binding = FragmentFirstBinding.inflate(inflater, container, false)
    return binding.root

  }

  override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
    super.onViewCreated(view, savedInstanceState)

    binding.buttonFirst.setOnClickListener {
      findNavController().navigate(R.id.action_FirstFragment_to_SecondFragment)
    }
    setListeners()
  }

  private fun setListeners() {
    if (quoteAllTheThings.m1) {
      binding.textviewFirst.addTextSpanWatcher(IndentSpanWatcher())
      binding.textviewFirst.addTextSpanWatcher(BeginningFormatEnabledWatcher())
    }
  }

  override fun onDestroyView() {
    super.onDestroyView()
    _binding = null
  }
}

private fun EditText.addTextSpanWatcher(watcher: TextSpanWatcher) {
  val existingWatcher =
    this.text
      .getSpans(0, this.length(), watcher::class.java)
      // Check for exact class in case inheritance is used in the future.
      .firstOrNull { it::class.java == watcher::class.java }
  if (existingWatcher != null) {
    // Currently there only ever needs to be one TextSpanWatcher of each type. This avoids the
    // inefficiency of having
    // duplicates.
    Log.d("addTextSpanWatcher","Using existing watcher, $existingWatcher, instead of adding new one, $watcher")
    existingWatcher.afterTextChanged(this.text)
  } else {
    Log.d("addTextSpanWatcher","NOT Using existing watcher, $existingWatcher, instead of adding new one, $watcher")
    this.addTextChangedListener(watcher)
    watcher.afterTextChanged(this.text)
  }
}
