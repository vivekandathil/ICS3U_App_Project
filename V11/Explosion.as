package
{
    import flash.display.GradientType;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.TimerEvent;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.utils.setTimeout;
    import flash.utils.Timer;

    public class Explosion extends Sprite
    {

        private var _radius:Number;
        private const MAX_RADIUS:Number = 15;
        private const MIN_RADIUS:Number = 10;

        private var _particleCount:int = 0;
        private const MAX_PARTICLES:int = 30;
        private const MIN_PARTICLES:int = 25;

        private const MIN_PARTICLE_RADIUS:int = 3;
        private const MAX_PARTICLE_RADIUS:int = 7;

        private var _particleCoreColor:uint = 0xffffff;
        private var _particleMiddleColor:uint = 0x00ffff;
        private var _particleOuterColor:uint = 0x0000ff;

        private var _particles:Vector.<Sprite> = new Vector.<Sprite>();

        private var _timer:Timer = new Timer(10);

        public function Explosion()
        {
            mouseEnabled = false;
            mouseChildren = false;
            addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        }

        private function onAddedToStage(e:Event):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

            _radius = (Math.random() * (MAX_RADIUS-MIN_RADIUS-1))+MIN_RADIUS;
            _particleCount = (Math.random() * (MAX_PARTICLES-MIN_PARTICLES-1)) + MIN_PARTICLES;

            for (var i:int = 0; i < _particleCount; i++)
            {
                setTimeout(createParticle, 20*(i+1));
            }

            _timer.addEventListener(TimerEvent.TIMER, onTick);
        }

        private function onTick(e:TimerEvent):void
        {
            for (var i:int = _particles.length-1; i >=0 ; --i)
            {
                _particles[i].scaleX += 0.2;
                _particles[i].scaleY += 0.2;
                _particles[i].alpha -= 0.03;
                if (_particles[i].alpha <= 0.0)
                {
                    removeChild(_particles[i]);
                    _particles.splice(i, 1);
                }
            }

            if (_particles.length == 0)
            {
                _timer.stop();
                _timer.removeEventListener(TimerEvent.TIMER, onTick);
				if(this.parent)
					this.parent.removeChild(this);
            }
        }

        private function createParticle():void
        {
            var sp:Sprite = new Sprite();

            var particleRadius:int = (Math.random() * (MAX_PARTICLE_RADIUS - MIN_PARTICLE_RADIUS - 1)) + MIN_PARTICLE_RADIUS;

            var mat:Matrix = new Matrix();
            mat.createGradientBox(particleRadius*2, particleRadius*2, 0,-particleRadius,-particleRadius);

            sp.graphics.beginGradientFill(GradientType.RADIAL, [_particleCoreColor, _particleMiddleColor,_particleOuterColor], [1.0, 1.0, 0.0], [0,170, 255], mat, "pad", "rgb", 0);
            sp.graphics.drawCircle(0, 0, particleRadius);
            sp.graphics.endFill();
			
            addChildAt(sp,0);

            var p:Point = new Point((Math.random() * 2) - 1, (Math.random() * 2) - 1);
            p.normalize(1);

            sp.x = p.x * (Math.random()*_radius);
            sp.y = p.y * (Math.random()*_radius);

            _particles.push(sp);


            if (!_timer.running) {
                _timer.start();
            }
        }

    }

}