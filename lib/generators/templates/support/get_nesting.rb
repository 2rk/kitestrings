def get_nesting(meta, other_ids = {})
  meta.metadata.select { |k, _| k.to_s.include?('_id') }
    .each_with_object({}) { |(k, v), hsh| hsh[k] = send(v).id }.reverse_merge(other_ids)
end
