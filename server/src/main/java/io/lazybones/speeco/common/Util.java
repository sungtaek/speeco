package io.lazybones.speeco.common;

import java.lang.reflect.Type;
import java.nio.ByteBuffer;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonElement;
import com.google.gson.JsonPrimitive;
import com.google.gson.JsonSerializationContext;
import com.google.gson.JsonSerializer;
import com.google.protobuf.ByteString;
import com.google.protobuf.Descriptors;
import com.google.protobuf.Descriptors.EnumValueDescriptor;
import com.google.protobuf.MessageOrBuilder;

public class Util {
  
  public static byte[] mergeBytes(Collection<byte[]> bytes) {
    int size = bytes.stream().map(b -> b.length).reduce(0, Integer::sum);
    ByteBuffer buf = ByteBuffer.wrap(new byte[size]);
    bytes.forEach(buf::put);
    return buf.array();
  }

  private static ObjectMapper om = new ObjectMapper();
  public static <T> T parseJson(String json, Class<T> clazz) {
    try {
      return om.readValue(json, clazz);
    } catch (JsonProcessingException e) {
      throw new RuntimeException(e);
    }
  }

  public static boolean isBlank(CharSequence cs) {
    return StringUtils.isBlank(cs);
  }

  public static boolean isEmpty(CharSequence cs) {
    return StringUtils.isEmpty(cs);
  }

  private static final Gson gsonForLog = new GsonBuilder()
      .registerTypeHierarchyAdapter(byte[].class, new JsonSerializer<byte[]>() {
        @Override
        public JsonElement serialize(byte[] src, Type typeOfSrc, JsonSerializationContext context) {
          return new JsonPrimitive(String.format("<bytes:%d>", src != null ? src.length : 0));
        }
      })
      .disableHtmlEscaping()
      .create();

  public static String toLogString(Object obj) {
    if (obj == null) {
      return "";
    }
    String namePrefix = obj.getClass().getSimpleName();
    if (obj instanceof MessageOrBuilder) {
      return namePrefix + gsonForLog.toJson(toMap((MessageOrBuilder) obj));
    } else {
      return namePrefix + gsonForLog.toJson(obj);
    }
  }

  private static Map<String, Object> toMap(MessageOrBuilder message) {
    Map<String, Object> map = new HashMap<>();
    for (Map.Entry<Descriptors.FieldDescriptor, Object> e : message.getAllFields().entrySet()) {
      Descriptors.FieldDescriptor desc = e.getKey();
      Object value = e.getValue();
      if (value instanceof ByteString) {
        value = ((ByteString)value).toByteArray();
      } else if (value instanceof EnumValueDescriptor) {
        value = String.format("%s(%d)", ((EnumValueDescriptor)value).getName(), ((EnumValueDescriptor)value).getNumber());
      } else if (value instanceof MessageOrBuilder) {
        value = toMap((MessageOrBuilder)value);
      }
      map.put(desc.getName(), value);
    }
    return map;
  }

}
