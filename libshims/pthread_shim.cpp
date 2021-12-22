#include "pthread_internal.h"

#include <errno.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>


#include "async_safe/log.h"
#include "private/ScopedRWLock.h"
#include "private/bionic_futex.h"
#include "private/bionic_tls.h"

static pthread_internal_t* g_thread_list = nullptr;
static pthread_rwlock_t g_thread_list_lock = PTHREAD_RWLOCK_INITIALIZER;

pthread_internal_t* __pthread_internal_find(pthread_t thread_id, const char* caller) {
  pthread_internal_t* thread = reinterpret_cast<pthread_internal_t*>(thread_id);

  // Check if we're looking for ourselves before acquiring the lock.
  if (thread == __get_thread()) return thread;

  {
    // Make sure to release the lock before the abort below. Otherwise,
    // some apps might deadlock in their own crash handlers (see b/6565627).
    ScopedReadLock locker(&g_thread_list_lock);
    for (pthread_internal_t* t = g_thread_list; t != nullptr; t = t->next) {
      if (t == thread) return thread;
    }
  }

    if (thread == nullptr) {
      async_safe_format_log(ANDROID_LOG_WARN, "libc", "hecked invalid pthread_t(0) passed to %s",caller);
    } else {
      async_safe_format_log(ANDROID_LOG_WARN,"libc"," hecked invalid pthread_t %p passed to %s", thread, caller);
    }
  return nullptr;
}
