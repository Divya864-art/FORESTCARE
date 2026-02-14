import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static Future<void> init() async {
    await Supabase.initialize(
      url: 'https://zobzammzikkcoaunmkvf.supabase.co',  // 🔑 Supabase project URL
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpvYnphbW16aWtrY29hdW5ta3ZmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQzMDg1NTAsImV4cCI6MjA2OTg4NDU1MH0.9ZCdqYryQWbR99jLQXLjP-ksWvyzau8gSjhzIoNVk6g',          // 🔑 anon key
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
