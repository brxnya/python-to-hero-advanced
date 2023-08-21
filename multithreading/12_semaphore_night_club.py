import threading
import time


class NightClub:
    def __init__(self):
        self.bounced = threading.Semaphore(3)

    def open_club(self):
        for x in range(1, 51):
            t = threading.Thread(target=self.guest, args=[x])
            t.start()

    def guest(self, guest_id):
        print(f'\nGuest {guest_id} is waiting to entering night club')
        self.bounced.acquire()

        print(f'\nGuest {guest_id} is doing some dancing')
        time.sleep(1)

        print(f'\nGuest {guest_id} is leaving the night club')
        self.bounced.release()


if __name__ == '__main__':
    club = NightClub()
    club.open_club()
