// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatMessageImpl _$$ChatMessageImplFromJson(Map<String, dynamic> json) =>
    _$ChatMessageImpl(
      id: json['id'] as String,
      content: json['content'] as String,
      isUser: json['isUser'] as bool,
      hasToolCalls: json['hasToolCalls'] as bool? ?? false,
      toolCalls: (json['toolCalls'] as List<dynamic>?)
              ?.map((e) => OpenAIToolCall.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ChatMessageImplToJson(_$ChatMessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'isUser': instance.isUser,
      'hasToolCalls': instance.hasToolCalls,
      'toolCalls': instance.toolCalls,
    };

_$OpenAIToolCallImpl _$$OpenAIToolCallImplFromJson(Map<String, dynamic> json) =>
    _$OpenAIToolCallImpl(
      name: json['name'] as String,
      arguments: json['arguments'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$$OpenAIToolCallImplToJson(
        _$OpenAIToolCallImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'arguments': instance.arguments,
    };
