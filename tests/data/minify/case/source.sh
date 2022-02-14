case name in
  name)
    echo "name"
  ;;
  roll)
    echo $(( 5 * 5 ))
  ;;
  *)
    echo "Operation not permitted"
  ;;
esac
