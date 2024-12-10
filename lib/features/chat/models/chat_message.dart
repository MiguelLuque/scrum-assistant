import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message.freezed.dart';
part 'chat_message.g.dart';

@freezed
class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String id,
    required String content,
    required bool isUser,
    @Default(false) bool hasToolCalls,
    @Default([]) List<OpenAIToolCall> toolCalls,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);
}

@freezed
class OpenAIToolCall with _$OpenAIToolCall {
  const factory OpenAIToolCall({
    required String name,
    required Map<String, dynamic> arguments,
  }) = _OpenAIToolCall;

  factory OpenAIToolCall.fromJson(Map<String, dynamic> json) =>
      _$OpenAIToolCallFromJson(json);
}
